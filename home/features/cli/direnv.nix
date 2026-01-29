{ config, lib, pkgs, ... }:

let
  cfg = config.features.cli.direnv;
in {
  options.features.cli.direnv.enable = lib.mkEnableOption "direnv with nix-direnv";

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
