{ config, lib, pkgs, ... }:

let
  cfg = config.features.devops.security;
in {
  options.features.devops.security.enable = lib.mkEnableOption "security scanning tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      grype
      trivy
      age
      sops
    ];
  };
}
