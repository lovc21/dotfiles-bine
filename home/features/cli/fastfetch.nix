{ config, lib, pkgs, ... }:

let
  cfg = config.features.cli.fastfetch;
in {
  options.features.cli.fastfetch.enable = lib.mkEnableOption "fastfetch system info";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ fastfetch ];
  };
}
