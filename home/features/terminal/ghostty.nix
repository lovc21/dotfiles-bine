{ config, lib, pkgs, ... }:

let
  cfg = config.features.terminal.ghostty;
in {
  options.features.terminal.ghostty.enable = lib.mkEnableOption "ghostty terminal configuration";

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        "shell-integration" = "detect";
        "shell-integration-features" = "cursor,sudo,title";

        "cursor-style" = "bar";

        "copy-on-select" = true;
        "clipboard-read" = "allow";
        "clipboard-write" = "allow";
        "clipboard-trim-trailing-spaces" = true;

        "window-padding-x" = "10,10";
        "window-padding-y" = "10,10";
        "window-decoration" = true;

        "scrollback-limit" = 1000000;
        "window-vsync" = true;

        "link-url" = true;

        "cursor-click-to-move" = true;
        "mouse-hide-while-typing" = true;

        keybind = [
          "ctrl+shift+x=close_surface"
          "ctrl+shift+j=goto_split:bottom"
          "ctrl+shift+k=goto_split:top"
          "ctrl+shift+h=goto_split:left"
          "ctrl+shift+l=goto_split:right"
        ];
      };
    };
  };
}
