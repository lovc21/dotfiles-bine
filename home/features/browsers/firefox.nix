{ config, lib, pkgs, ... }:

let
  cfg = config.features.browsers.firefox;
in {
  options.features.browsers.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      firefox
    ];
  };
}
