{ config, lib, ... }:

let
  cfg = config.features.cli.atuin;
in {
  options.features.cli.atuin.enable = lib.mkEnableOption "atuin shell history";

  config = lib.mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = false;
        update_check = false;
        search_mode = "fuzzy";
        filter_mode = "global";
        filter_mode_shell_up_key_binding = "session";
        style = "compact";
        inline_height = 20;
        show_preview = true;
        enter_accept = false;
        keymap_mode = "auto";
      };
    };
  };
}
