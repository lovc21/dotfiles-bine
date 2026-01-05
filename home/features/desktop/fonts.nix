{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.fonts;
in {
  options.features.desktop.fonts.enable =
    mkEnableOption "install additional fonts for desktop apps";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # JetBrains Mono - primary font
      nerd-fonts.jetbrains-mono
      
      # Additional coding fonts
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.monaspace
      
      # Font management
      font-manager
      
      # Icon fonts
      font-awesome
      
      # System fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    # Font configuration
    fonts.fontconfig.enable = true;
  };
}
