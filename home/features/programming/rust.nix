{ config, lib, pkgs, ... }:

let
  cfg = config.features.programming.rust;
in {
  options.features.programming.rust.enable = lib.mkEnableOption "Rust toolchain";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rustc
      cargo
      rust-analyzer
    ];
  };
}
