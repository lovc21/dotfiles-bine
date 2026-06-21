{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.features.cli.ai;
in
{
  options.features.cli.ai.enable = lib.mkEnableOption "AI CLI tools (Claude & Gemini)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gemini-cli
      claude-code
      opencode
      code2prompt
      inputs.llmfit.packages.${pkgs.system}.default
    ];

    home.sessionVariables.ANTHROPIC_MODEL = "claude-opus-4-8";
  };
}
