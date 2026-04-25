{ config, lib, pkgs, ... }:

let
  cfg = config.features.llms.ollama;
in {
  options.features.llms.ollama.enable = lib.mkEnableOption "Ollama local LLM runner";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ollama
    ];
  };
}
