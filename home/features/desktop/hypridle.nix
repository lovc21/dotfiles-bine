{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.hypridle;
in {
  options.features.desktop.hypridle.enable = mkEnableOption "hypridle idle daemon";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hypridle
    ];

    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || hyprlock
          before_sleep_cmd = loginctl lock-session
          after_sleep_cmd = hyprctl dispatch dpms on
      }

      listener {
          timeout = 150
          on-timeout = brightnessctl -s set 10
          on-resume = brightnessctl -r
      }

      listener {
          timeout = 300
          on-timeout = loginctl lock-session
      }

      listener {
          timeout = 330
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
      }

      listener {
          timeout = 1800
          on-timeout = systemctl suspend
      }
    '';
  };
}
