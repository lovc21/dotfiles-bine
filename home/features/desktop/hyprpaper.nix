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
    # Stylix also targets hyprpaper — we manage the config ourselves here,
    # so let Stylix handle the base16 colors in other apps only.
    # mkForce beats the default `true` set by stylix's hyprland module.
    stylix.targets.hyprpaper.enable = mkForce false;

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
