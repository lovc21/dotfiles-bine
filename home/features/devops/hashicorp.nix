{ config, lib, pkgs, ... }:

let
  cfg = config.features.devops.hashicorp;
in {
  options.features.devops.hashicorp.enable = lib.mkEnableOption "HashiCorp tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      packer
      vault
      ansible
    ];
  };
}
