{ config, lib, pkgs, ... }:

let
  cfg = config.features.terminal.ghostty;
in {
  options.features.terminal.ghostty.enable = lib.mkEnableOption "ghostty terminal configuration";

  config = lib.mkIf cfg.enable {
    # Install Ghostty
    home.packages = with pkgs; [
      ghostty
    ];

    # Ghostty configuration file
    home.file.".config/ghostty/config".text = ''
      # Background Transparency
      background-opacity = 0.8
      
      # Tokyo Night Color Scheme
      background = 1a1b26
      foreground = c0caf5
      
      # Normal colors
      palette = 0=#15161e
      palette = 1=#f7768e
      palette = 2=#9ece6a
      palette = 3=#e0af68
      palette = 4=#7aa2f7
      palette = 5=#bb9af7
      palette = 6=#7dcfff
      palette = 7=#a9b1d6
      
      # Bright colors
      palette = 8=#414868
      palette = 9=#f7768e
      palette = 10=#9ece6a
      palette = 11=#e0af68
      palette = 12=#7aa2f7
      palette = 13=#bb9af7
      palette = 14=#7dcfff
      palette = 15=#c0caf5
      
      # Cursor colors
      cursor-color = c0caf5
      cursor-text = 1a1b26
      
      # Selection colors
      selection-background = ff79c6
      selection-foreground = 282c34
      
      # Font Settings
      font-family = "JetBrains Mono"
      font-size = 14
      font-family-bold = "JetBrains Mono Bold"
      font-family-italic = "JetBrains Mono Italic"
      font-family-bold-italic = "JetBrains Mono Bold Italic"
      
      # Shell Integration
      shell-integration = detect
      shell-integration-features = cursor, sudo, title
      
      # Cursor Settings
      cursor-style = bar
      cursor-opacity = 1
      
      # Clipboard Settings
      copy-on-select = true
      clipboard-read = allow
      clipboard-write = allow
      clipboard-trim-trailing-spaces = true
      
      # Window Padding and Decoration
      window-padding-x = 10,10
      window-padding-y = 10,10
      window-decoration = true
      
      # Scrollback and Performance
      scrollback-limit = 1000000
      window-vsync = true
      
      # Link Handling
      link-url = true
      
      # Enable Click-to-Move Cursor
      cursor-click-to-move = true
      
      # Enable Hide Mouse While Typing
      mouse-hide-while-typing = true
      
      # Keybindings
      keybind = ctrl+shift+x=close_surface
      keybind = ctrl+shift+j=goto_split:bottom
      keybind = ctrl+shift+k=goto_split:top
      keybind = ctrl+shift+h=goto_split:left
      keybind = ctrl+shift+l=goto_split:right
    '';
  };
}
