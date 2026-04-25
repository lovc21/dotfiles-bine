{ config, lib, pkgs, ... }:

let
  cfg = config.features.browsers.google-chrome;
in {
  options.features.browsers.google-chrome.enable = lib.mkEnableOption "Google Chrome";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
