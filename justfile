
default:
    @just --list

# Build NixOS configuration without switching
[group('nixos-test')]
build:
    sudo nixos-rebuild build --flake .#bine

# Test build (temporary, doesn't persist after reboot)
[group('nixos-test')]
test:
    sudo nixos-rebuild test --flake .#bine

# Check flake for errors
[group('nixos-test')]
check:
    nix flake check --show-trace

# Build and switch to new configuration
[group('nixos-test')]
deploy: build diff
    sudo nixos-rebuild switch --flake .#bine

# Show what will change compared to current system
[group('nixos-test')]
diff:
    #!/usr/bin/env bash
    nix store diff-closures /run/current-system ./result

# Clean old generations (older than 7 days)
[group('nix')]
clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
    nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager --older-than 7d
    sudo nix-collect-garbage --delete-older-than 7d

# Show generation history
[group('nix')]
history:
    nix profile history --profile /nix/var/nix/profiles/system

