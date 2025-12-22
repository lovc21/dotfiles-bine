# Common configuration for all hosts
{
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
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modificationsls
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
}

