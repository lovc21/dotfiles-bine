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

    xdg.configFile."hypr/hyprpaper.conf".text = let
      wp = "${config.home.homeDirectory}/Pictures/wallpapers/b-180.jpg";
    in ''
      splash = false
      ipc = on

      wallpaper {
          monitor = *
          path = ${wp}
          fit_mode = cover
      }
    '';
  };
}
