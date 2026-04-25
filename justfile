
default:
    @just --list

# Build NixOS configuration without switching
[group('nixos-test')]
build:
    nh os build .

# Test build (temporary, doesn't persist after reboot)
[group('nixos-test')]
test:
    nh os test .

# Check flake for errors
[group('nixos-test')]
check:
    nix flake check --show-trace

# Build and switch to new configuration
[group('nixos-test')]
deploy:
    nh os switch .

# Update flake inputs
[group('nix')]
update:
    nix flake update

# Clean old generations (older than 7 days)
[group('nix')]
clean:
    nh clean all --keep-since 7d --keep 3

# Show generation history
[group('nix')]
history:
    nix profile history --profile /nix/var/nix/profiles/system

# Capture power / ASPM / PSR / firewall / cursor snapshot
[group('diagnostics')]
bench:
    bash scripts/bench.sh

# Diff the two most recent bench runs
[group('diagnostics')]
bench-diff:
    bash scripts/bench.sh diff
