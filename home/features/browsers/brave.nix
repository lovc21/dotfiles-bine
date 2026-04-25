{ config, lib, pkgs, ... }:

let
  cfg = config.features.browsers.brave;
in {
  options.features.browsers.brave.enable = lib.mkEnableOption "Brave";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      brave
    ];
  };
}
