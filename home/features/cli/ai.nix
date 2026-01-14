{ config, lib, pkgs, ... }:

let
  cfg = config.features.cli.ai;
in {
  options.features.cli.ai.enable = lib.mkEnableOption "AI CLI tools (Claude & Gemini)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gemini-cli
      claude-code
    ];

  };
}
