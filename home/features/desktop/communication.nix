{ config, lib, pkgs, ... }:

let
  cfg = config.features.desktop.communication;
in {
  options.features.desktop.communication.enable = lib.mkEnableOption "chat / communication apps";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
      discord
    ];
  };
}
