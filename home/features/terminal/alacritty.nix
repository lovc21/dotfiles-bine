{ config, lib, pkgs, ... }:

let
  cfg = config.features.terminal.alacritty;
in {
  options.features.terminal.alacritty.enable = lib.mkEnableOption "Alacritty terminal";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      alacritty
    ];
  };
}
