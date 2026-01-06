{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprpaper;
in {
  options.features.desktop.hyprpaper = {
    enable = mkEnableOption "hyprpaper wallpaper daemon";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpaper
    ];

    home.file."Pictures/wallpapers/.keep".text = "";

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ~/Pictures/wallpapers/b-180.jpg

      wallpaper = eDP-1, ~/Pictures/wallpapers/b-180.jpg
      wallpaper = DP-1, ~/Pictures/wallpapers/b-180.jpg
      wallpaper = DP-2, ~/Pictures/wallpapers/b-180.jpg

      splash = false
      ipc = on
    '';
  };
}
