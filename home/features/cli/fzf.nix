{ config, lib, ... }:

let
  cfg = config.features.cli.fzf;
in
{
  options.features.cli.fzf.enable = lib.mkEnableOption "fuzzy finder";

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      defaultOptions = [
        "--preview='bat --color=always -n {}'"
        "--bind 'ctrl-/:toggle-preview'"
      ];

      defaultCommand = "fd --type f --exclude .git --follow --hidden";
      changeDirWidget.command = "fd --type d --exclude .git --follow --hidden";

      # atuin owns ctrl-r; disable fzf's competing history binding
      historyWidget.command = "";
    };
  };
}
