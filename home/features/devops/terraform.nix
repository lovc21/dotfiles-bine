{ config, lib, pkgs, ... }:

let
  cfg = config.features.devops.terraform;
in {
  options.features.devops.terraform.enable = lib.mkEnableOption "terraform tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      terraform
      terraform-ls
      tflint
    ];
  };
}
