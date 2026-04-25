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
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 5;
          hide_cursor = true;
          no_fade_in = false;
          no_fade_out = false;
        };

        auth = {
          "fingerprint:enabled" = true;
        };

        background = {
          monitor = "";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };

        input-field = {
          monitor = "";
          size = "300, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          fade_on_empty = false;
          fade_timeout = 1000;
          placeholder_text = "<i>Password or Fingerprint...</i>";
          hide_input = false;
          rounding = 15;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_timeout = 2000;
          fail_transition = 300;
          invert_numlock = false;
          swap_font_color = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        };

        label = [
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
            font_size = 90;
            position = "0, 200";
            halign = "center";
            valign = "center";
            shadow_passes = 5;
            shadow_size = 10;
          }
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
            font_size = 24;
            position = "0, 110";
            halign = "center";
            valign = "center";
            shadow_passes = 5;
            shadow_size = 10;
          }
          {
            monitor = "";
            text = "Hello, Jakob";
            font_size = 18;
            position = "0, 50";
            halign = "center";
            valign = "center";
            shadow_passes = 5;
            shadow_size = 10;
          }
          {
            monitor = "";
            text = "$LAYOUT";
            font_size = 12;
            position = "0, -80";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
