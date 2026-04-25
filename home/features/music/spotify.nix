{ config, lib, pkgs, ... }:

let
  cfg = config.features.music.spotify;
in {
  options.features.music.spotify.enable = lib.mkEnableOption "Spotify";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
