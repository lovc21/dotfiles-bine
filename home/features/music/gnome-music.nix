{ config, lib, pkgs, ... }:

let
  cfg = config.features.music.gnome-music;
in {
  options.features.music.gnome-music.enable = lib.mkEnableOption "GNOME Music";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome-music
    ];
  };
}
