{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.devops.devcontainers;
in
{
  options.features.devops.devcontainers.enable = lib.mkEnableOption "dev containers tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      devcontainer
    ];
  };
}
