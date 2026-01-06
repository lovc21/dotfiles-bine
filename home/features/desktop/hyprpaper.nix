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
      preload = ~/home/bine/Downloads/b-098.jpg

      wallpaper = eDP-1, ~/home/bine/Downloads/b-098.jpg
      wallpaper = DP-1, ~/home/bine/Downloads/b-098.jpg
      wallpaper = DP-2, ~/home/bine/Downloads/b-098.jpg
      splash = false
      splash_offset = 2.0
      ipc = on
    '';
  };
}
