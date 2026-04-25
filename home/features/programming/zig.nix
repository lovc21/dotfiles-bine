{ config, lib, pkgs, ... }:

let
  cfg = config.features.programming.zig;
in {
  options.features.programming.zig.enable = lib.mkEnableOption "Zig toolchain";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zig
    ];
  };
}
