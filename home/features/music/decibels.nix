{ config, lib, pkgs, ... }:

let
  cfg = config.features.music.decibels;
in {
  options.features.music.decibels.enable = lib.mkEnableOption "Decibels audio player";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      decibels
    ];
  };
}
