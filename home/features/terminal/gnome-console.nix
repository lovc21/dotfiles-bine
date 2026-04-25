{ config, lib, pkgs, ... }:

let
  cfg = config.features.terminal.gnome-console;
in {
  options.features.terminal.gnome-console.enable = lib.mkEnableOption "GNOME Console (Kgx)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome-console
    ];
  };
}
