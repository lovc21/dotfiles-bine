{
  description = ''
    Jakob's NixOS configuration
  '';

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # use the one week old nixpkgs, because of the supply chain attacks
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-stable.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-26.05-chilled/0.1";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    dotfiles = {
      url = "git+https://github.com/lovc21/dotfiles-bine.git";
      flake = false;
    };

    llmfit = {
      url = "github:AlexsJones/llmfit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      treefmtEval = forAllSystems (
        system: inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };

      # `nix fmt` formats the whole repo (nixfmt + deadnix + statix).
      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      # `nix flake check` fails if anything is unformatted or has dead code.
      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
      nixosConfigurations = {
        bine = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/bine
            inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
            # inputs.disko.nixosModules.disko
          ];
        };
      };
      homeConfigurations = {
        "bine" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/bine/bine.nix ];
        };
      };
    };
}
