{ config, lib, pkgs, ... }:

let
  cfg = config.features.programming.go;
in {
  options.features.programming.go.enable = lib.mkEnableOption "Go toolchain";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      gopls
      golangci-lint
      delve
    ];
  };
}
