#!/usr/bin/env bash

set -uo pipefail

BENCH_DIR="/tmp/bench"
mkdir -p "$BENCH_DIR"

if [[ "${1:-}" == "diff" ]]; then
  mapfile -t files < <(ls -1t "$BENCH_DIR"/*.txt 2>/dev/null | head -2)
  if ((${#files[@]} < 2)); then
    echo "need at least 2 runs in $BENCH_DIR (have ${#files[@]})" >&2
    exit 1
  fi
  echo "older: ${files[1]}"
  echo "newer: ${files[0]}"
  echo
  diff -u "${files[1]}" "${files[0]}" || true
  exit 0
fi

gen=$(readlink /nix/var/nix/profiles/system 2>/dev/null | sed 's|.*system-||; s|-link||')
gen=${gen:-unknown}
ts=$(date +%Y%m%d-%H%M%S)
out="$BENCH_DIR/bench-${gen}-${ts}.txt"

bat_dir=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)

{
  echo "=== meta ==="
  echo "timestamp     : $(date -Iseconds)"
  echo "nixos-version : $(nixos-version 2>/dev/null)"
  echo "generation    : $gen"
  echo "system path   : $(readlink /nix/var/nix/profiles/system)"
  echo "kernel        : $(uname -r)"
  echo "cmdline       : $(cat /proc/cmdline)"
  echo

  echo "=== idle power (W, 10 samples @ 1s, screen on, no activity) ==="
  read_power_w() {
    # prefer power_now (µW), fall back to upower energy-rate (W)
    local uw
    uw=$(cat "$bat_dir/power_now" 2>/dev/null || echo 0)
    if [[ "$uw" -gt 0 ]] 2>/dev/null; then
      awk -v x="$uw" 'BEGIN{printf "%.2f", x/1000000}'
      return
    fi
    LC_ALL=C upower -i "$(upower -e | grep BAT | head -1)" 2>/dev/null |
      awk '/energy-rate/ {printf "%.2f", $2}'
  }
  if [[ -n "$bat_dir" ]] && command -v upower >/dev/null; then
    sum=0
    for _ in {1..10}; do
      w=$(read_power_w)
      w=${w:-0.00}
      echo "  $w W"
      sum=$(awk -v a="$sum" -v b="$w" 'BEGIN{printf "%.2f", a+b}')
      sleep 1
    done
    avg=$(awk -v s="$sum" 'BEGIN{printf "%.2f", s/10}')
    echo "  avg: $avg W"
  else
    echo "  no battery or upower not found"
  fi
  echo

  echo "=== battery ==="
  acpi -b 2>/dev/null || echo "  acpi not available"
  if command -v upower >/dev/null; then
    upower -i "$(upower -e | grep BAT | head -1)" 2>/dev/null |
      grep -E "state|time to|percentage|energy-rate" | sed 's/^/  /'
  fi
  echo

  echo "=== cpu ==="
  echo "  scaling_driver : $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver 2>/dev/null)"
  echo "  governor       : $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)"
  echo "  epp            : $(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null)"
  echo "  boost          : $(cat /sys/devices/system/cpu/cpufreq/boost 2>/dev/null)"
  echo

  echo "=== pcie aspm ==="
  if sudo -n true 2>/dev/null; then
    sudo lspci -vv 2>/dev/null |
      grep -iE "aspm.+(enabled|disabled)" |
      sed -E 's/^[[:space:]]+/  /' | sort -u
    echo "  policy: $(cat /sys/module/pcie_aspm/parameters/policy 2>/dev/null)"
  else
    echo "  needs sudo (run: sudo -v)"
  fi
  echo

  echo "=== panel self-refresh (amdgpu) ==="
  if sudo -n true 2>/dev/null; then
    for f in /sys/kernel/debug/dri/*/eDP-1/psr_state /sys/kernel/debug/dri/*/amdgpu_dm_psr_capability; do
      [[ -r "$f" ]] && echo "  $f: $(sudo cat "$f" 2>/dev/null)"
    done
  else
    echo "  needs sudo"
  fi
  echo

  echo "=== firewall ==="
  if sudo -n true 2>/dev/null; then
    lines=$(sudo nft list ruleset 2>/dev/null | wc -l)
    echo "  nftables rule lines : $lines"
    echo "  state               : $([[ $lines -gt 5 ]] && echo active || echo empty)"
  else
    echo "  needs sudo"
  fi
  echo

  echo "=== zram / swap ==="
  swapon --show=NAME,TYPE,SIZE,USED 2>/dev/null || echo "  no swap"
  echo

  echo "=== power-profiles-daemon ==="
  if command -v powerprofilesctl >/dev/null; then
    echo "  active  : $(powerprofilesctl get 2>/dev/null)"
    powerprofilesctl list 2>/dev/null | grep -E "^\* |^  [a-z]" | sed 's/^/  /'
  else
    echo "  not installed"
  fi
  echo

  echo "=== hyprland cursor (from logs, last 5 matches) ==="
  grep -iE "cursor.*(hw|sw)|WLR_NO_HARDWARE" \
    ~/.local/share/hyprland/hyprland_*.log \
    ~/.cache/hyprland/hyprland_*.log 2>/dev/null |
    tail -5 | sed 's/^/  /' || echo "  no matching log lines"
  echo

  echo "=== memory ==="
  free -h | sed 's/^/  /'
} >"$out"

echo "wrote $out"
echo
echo "compare two runs: bash scripts/bench.sh diff"
