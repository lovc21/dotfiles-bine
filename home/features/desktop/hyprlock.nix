{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprlock;
in {
  options.features.desktop.hyprlock.enable = mkEnableOption "hyprlock screen locker";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprlock
    ];

    xdg.configFile."hypr/hyprlock.conf".text = ''
      general {
          disable_loading_bar = true
          grace = 5
          hide_cursor = true
          no_fade_in = false
          no_fade_out = false
      }

      background {
          monitor =
          path = screenshot
          blur_passes = 3
          blur_size = 8
          noise = 0.0117
          contrast = 0.8916
          brightness = 0.8172
          vibrancy = 0.1696
          vibrancy_darkness = 0.0
      }

      input-field {
          monitor =
          size = 300, 50
          outline_thickness = 3
          dots_size = 0.33
          dots_spacing = 0.15
          dots_center = true
          dots_rounding = -1
          outer_color = rgb(7aa2f7)
          inner_color = rgb(1a1b26)
          font_color = rgb(c0caf5)
          fade_on_empty = true
          fade_timeout = 1000
          placeholder_text = <i>Password...</i>
          hide_input = false
          rounding = 15
          check_color = rgb(9ece6a)
          fail_color = rgb(f7768e)
          fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
          fail_timeout = 2000
          fail_transition = 300
          capslock_color = rgb(e0af68)
          numlock_color = -1
          bothlock_color = -1
          invert_numlock = false
          swap_font_color = false
          position = 0, -20
          halign = center
          valign = center
      }

      label {
          monitor =
          text = cmd[update:1000] echo "$(date +"%H:%M")"
          color = rgb(c0caf5)
          font_size = 90
          font_family = JetBrainsMono Nerd Font
          position = 0, 200
          halign = center
          valign = center
          shadow_passes = 5
          shadow_size = 10
      }

      label {
          monitor =
          text = cmd[update:1000] echo "$(date +"%A, %B %d")"
          color = rgb(7aa2f7)
          font_size = 24
          font_family = JetBrainsMono Nerd Font
          position = 0, 110
          halign = center
          valign = center
          shadow_passes = 5
          shadow_size = 10
      }

      label {
          monitor =
          text = Hello, $USER
          color = rgb(bb9af7)
          font_size = 18
          font_family = JetBrainsMono Nerd Font
          position = 0, 50
          halign = center
          valign = center
          shadow_passes = 5
          shadow_size = 10
      }

      label {
          monitor =
          text = $LAYOUT
          color = rgb(565f89)
          font_size = 12
          font_family = JetBrainsMono Nerd Font
          position = 0, -80
          halign = center
          valign = center
      }
    '';
  };
}
