{ config, lib, pkgs, ... }:

let
  cfg = config.features.programming.python;
in {
  options.features.programming.python.enable = lib.mkEnableOption "Python toolchain";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pipx
      python312
      python312Packages.pip
      pyright
      ruff
    ];
  };
}
