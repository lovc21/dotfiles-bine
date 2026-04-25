{ config, lib, pkgs, ... }:

let
  cfg = config.features.devops.docker;
in {
  options.features.devops.docker.enable = lib.mkEnableOption "docker tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      docker-compose
      lazydocker
      dive
    ];
  };
}
