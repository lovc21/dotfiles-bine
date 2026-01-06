{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprland;
in {
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland config";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        xwayland = {
          force_zero_scaling = true;
        };

        exec-once = [
          "waybar"
          "hyprpaper"
          "hypridle"
          "wl-paste -p -t text --watch clipman store -P --histpath=\"~/.local/share/clipman-primary.json\""
        ];

        env = [
          "XCURSOR_SIZE,32"
          "WLR_NO_HARDWARE_CURSORS,1"
          "GTK_THEME,Tokyonight-Dark"
          "XCURSOR_THEME,Bibata-Modern-Ice"
        ];

        gesture = [
          "3, horizontal, workspace"
        ];

        monitor = [
        # Laptop - 2880x1920 @ 120Hz, scale 2 (left)
        "eDP-1, 2880x1920@120, 0x0, 2"
        
        # Dell 4K - 3840x2160 @ 60Hz (center, to the right of laptop)
        "DP-1, 3840x2160@60, 1440x0, 1"
        
        # Dell 1080p - rotated left (portrait), to the right of 4K
        "DP-2, 1920x1080@60, 5280x0, 1, transform, 3"
        
        ", preferred, auto, 1"
       ];

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_rules = "";
          kb_options = "ctrl:nocaps";
          follow_mouse = 1;

          touchpad = {
            natural_scroll = true;
          };

          sensitivity = 0;
        };

        # Tokyo Night color scheme
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg";
          "col.inactive_border" = "rgba(414868aa)";
          layout = "dwindle";
        };
        
        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 5;
            passes = 3;
            new_optimizations = true;
          };
          active_opacity = 0.95;
          inactive_opacity = 0.85;
          shadow = {
            enabled = true;
            range = 60;
            offset = "1 2";
            render_power = 3;
            scale = 0.97;
            color = "rgba(1a1b2666)";
          };
        };
                
        animations = {
          enabled = true;
          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
            "linear, 0.0, 0.0, 1.0, 1.0"
          ];
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {};
         
        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, return, exec, ghostty"
          "$mainMod, t, exec, ghostty"
          "$mainMod, o, exec, nautilus"
          "$mainMod, b, exec, firefox"
          "$mainMod, Escape, exec, wlogout -p layer-shell"
          "$mainMod, q, killactive"
          "$mainMod, M, exit"
          "$mainMod, F, fullscreen"
          "$mainMod, V, togglefloating"
          "$mainMod, Space, togglefloating"
          "$mainMod, P, pseudo"
          "$mainMod, J, togglesplit"
          "$mainMod, D, exec, wofi --show drun --allow-images"
          "$mainMod, R, exec, wofi --show run"
          ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
          "$mainMod, Print, exec, grim - | wl-copy"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          "$mainMod SHIFT, L, exec, loginctl lock-session"
          "CTRL ALT, left, workspace, m-1"
          "CTRL ALT, right, workspace, m+1"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ];

        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];

        windowrulev2 = [
          "float, class:(file_progress)"
          "float, class:(confirm)"
          "float, class:(dialog)"
          "float, class:(download)"
          "float, class:(notification)"
          "float, class:(error)"
          "float, class:(splash)"
          "float, class:(confirmreset)"
          "float, title:(Open File)"
          "float, title:(branchdialog)"
          "float, class:(Lxappearance)"
          "float, class:(wofi)"
          "float, class:(dunst)"
          "noanim, class:(wofi)"
          "float, class:(viewnior)"
          "float, class:(feh)"
          "float, class:(pavucontrol-qt)"
          "float, class:(pavucontrol)"
          "float, class:(file-roller)"
          "fullscreen, class:(wlogout)"
          "float, title:(wlogout)"
          "fullscreen, title:(wlogout)"
          "idleinhibit focus, class:(mpv)"
          "idleinhibit fullscreen, class:(firefox)"
          "float, title:(Media viewer)"
          "float, title:(Volume Control)"
          "float, title:(Picture-in-Picture)"
          "size 800 600, title:(Volume Control)"
          "move 75 44%, title:(Volume Control)"
          "workspace 2, class:(firefox)"
          "workspace 2, class:(brave-browser)"
          "workspace 3, class:(Slack)"
          "workspace 4, class:(discord)"
          "workspace 5, class:(spotify)"
          "opacity 1.0, class:(firefox)"
          "opacity 1.0, class:(brave-browser)"
        ];
        
        workspace = [
          "1, monitor:eDP-1, default:true"
          "2, monitor:DP-1, default:true"
          "3, monitor:DP-2, default:true"
          "4, monitor:eDP-1"
          "5, monitor:DP-1"
          "6, monitor:DP-2"
          "7, monitor:eDP-1"
          "8, monitor:DP-1"
          "9, monitor:DP-2"
        ];
      };
    };

    home.packages = with pkgs; [
      hyprpaper
      hypridle
      hyprlock
      brightnessctl
      playerctl
    ];
  };
}
