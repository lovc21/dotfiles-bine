{ config, lib, pkgs, ... }:

let
  cfg = config.features.terminal.xterm;
in {
  options.features.terminal.xterm.enable = lib.mkEnableOption "XTerm";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      xterm
    ];
  };
}
