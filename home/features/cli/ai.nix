{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.features.cli.ai;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.features.cli.ai = {
    enable = lib.mkEnableOption "AI CLI tools (Claude & Gemini)";

    herdr.settings = lib.mkOption {
      inherit (tomlFormat) type;
      default = { };
      description = "herdr settings, written to ~/.config/herdr/config.toml";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gemini-cli
      claude-code
      opencode
      code2prompt
      inputs.llmfit.packages.${pkgs.system}.default
      inputs.herdr-nix.packages.${pkgs.system}.default
    ];

    xdg.configFile."herdr/config.toml" = lib.mkIf (cfg.herdr.settings != { }) {
      source = tomlFormat.generate "herdr-config" cfg.herdr.settings;
    };
  };
}
