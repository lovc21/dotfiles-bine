{ config, lib, pkgs, ... }:

let
  cfg = config.features.cli.neofetch;
in {
  options.features.cli.neofetch.enable = lib.mkEnableOption "neofetch system info";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ neofetch ];
  };
}
