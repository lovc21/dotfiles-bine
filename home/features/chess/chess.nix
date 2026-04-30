{ config, lib, pkgs, ... }:

let
  cfg = config.features.chess;
in {
  options.features.chess.enable =
    lib.mkEnableOption "Chess engine testing tools (cutechess + stockfish)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cutechess
      stockfish
    ];
  };
}
