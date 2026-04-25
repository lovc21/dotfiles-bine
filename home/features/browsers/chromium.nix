{ config, lib, pkgs, ... }:

let
  cfg = config.features.browsers.chromium;
in {
  options.features.browsers.chromium.enable = lib.mkEnableOption "Chromium";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      chromium
    ];
  };
}
