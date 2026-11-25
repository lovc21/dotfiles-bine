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
      antigravity-cli
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
      opencode
      code2prompt
      inputs.llmfit.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.herdr-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      (pkgs.writeShellApplication {
        name = "claude-statusline";
        runtimeInputs = [ pkgs.jq ];
        text = ''
          input=$(cat)
          if [[ -z "''${CLAUDE_CONFIG_DIR:-}" ]]; then
            account=main color=33 state="$HOME/.claude.json"
          elif [[ "$CLAUDE_CONFIG_DIR" == "$HOME/.claude-backup" ]]; then
            account=backup color=35 state="$CLAUDE_CONFIG_DIR/.claude.json"
          else
            account=$(basename "$CLAUDE_CONFIG_DIR") color=36 state="$CLAUDE_CONFIG_DIR/.claude.json"
          fi
          email=$(jq -r '.oauthAccount.emailAddress // "not logged in"' "$state" 2>/dev/null || echo "not logged in")
          model=$(jq -r '.model.display_name // ""' <<<"$input")
          dir=$(jq -r '.workspace.current_dir // ""' <<<"$input")
          printf '\e[%sm● %s\e[0m \e[2m·\e[0m %s \e[2m·\e[0m %s \e[2m·\e[0m %s\n' \
            "$color" "$account" "$email" "$model" "''${dir/#$HOME/\~}"
        '';
      })
    ];

    programs.zsh.initContent = ''
      claude-switch() {
        case "$1" in
          main)
            unset CLAUDE_CONFIG_DIR
            export CLAUDE_ACCOUNT=main
            ;;
          backup)
            mkdir -p "$HOME/.claude-backup"
            export CLAUDE_CONFIG_DIR="$HOME/.claude-backup"
            export CLAUDE_ACCOUNT=backup
            ;;
          *)
            echo "Usage: claude-switch [main|backup]" >&2
            return 1
            ;;
        esac
        echo "Claude Code account: $CLAUDE_ACCOUNT"
      }
      alias c1="claude-switch main"
      alias c2="claude-switch backup"
      [[ -n "$CLAUDE_ACCOUNT" ]] || claude-switch main >/dev/null
    '';

    xdg.configFile."herdr/config.toml" = lib.mkIf (cfg.herdr.settings != { }) {
      source = tomlFormat.generate "herdr-config" cfg.herdr.settings;
    };
  };
}
