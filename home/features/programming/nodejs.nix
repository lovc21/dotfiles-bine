{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.programming.nodejs;
in
{
  options.features.programming.nodejs.enable = lib.mkEnableOption "Node.js toolchain";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_22
      prettier
      typescript-language-server
      pnpm
    ];

    home.sessionVariables = {
      npm_config_ignore_scripts = "true";
      pnpm_config_minimum_release_age = "10080";
    };
  };
}
