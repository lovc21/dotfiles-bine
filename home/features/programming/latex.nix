{ config, lib, pkgs, ... }:

let
  cfg = config.features.programming.latex;
in {
  options.features.programming.latex.enable = lib.mkEnableOption "LaTeX toolchain";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      texlive.combined.scheme-full
      texlab
      zathura
    ];
  };
}
