# Common configuration for all hosts
{ 
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {

  imports = [
    ./users
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs;};
    backupFileExtension = "backup";
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      # Auto-optimize when building
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "bine"
      ]; # Set users that are allowed to use the flake command
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
        "https://lovc21.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "lovc21.cachix.org-1:RDw/B/PYK6/d7Vwr6Bu4il5w5XhPlCrflMvsTIgHQEI="
      ];
    };
    # Configure automatic garbage collection for NixOS state;
    # this controls the number of generations that are kept
    # inside of the Nix store and thus the number of system
    # configurations that are available for selection at boot
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
      randomizedDelaySec = "1 hour";
    };
    # Optimize Nix store (saves disk space)
    optimise = {
     automatic = true;
     dates = [ "weekly" ];
    };
    registry =
      (lib.mapAttrs (_: flake: {inherit flake;}))
      ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    nixPath = ["/etc/nix/path"];
  };
  # Limit boot menu entries
  boot.loader.systemd-boot.configurationLimit = 10;

  # setpu zsh 
  users.defaultUserShell = pkgs.zsh;

  # Enable YubiKey support
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
}

