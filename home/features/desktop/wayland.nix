{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayland;
in {
  options.features.desktop.wayland.enable = mkEnableOption "wayland extra tools and config";

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      style = ''
        @define-color background #1a1b26;
        @define-color background-alt #24283b;
        @define-color foreground #c0caf5;
        @define-color comment #565f89;
        @define-color cyan #7dcfff;
        @define-color green #9ece6a;
        @define-color orange #ff9e64;
        @define-color pink #bb9af7;
        @define-color purple #9d7cd8;
        @define-color red #f7768e;
        @define-color yellow #e0af68;
        @define-color blue #7aa2f7;

        * {
            border: none;
            border-radius: 0;
            font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
            font-weight: bold;
            font-size: 14px;
            min-height: 0;
        }

        window#waybar {
            background: transparent;
            color: @foreground;
        }

        tooltip {
            background: @background;
            border-radius: 10px;
            border: 2px solid @blue;
        }

        tooltip label {
            color: @foreground;
        }

        #workspaces button {
            padding: 5px 10px;
            color: @comment;
            margin-right: 5px;
            background: @background;
            border-radius: 10px;
        }

        #workspaces button.active {
            color: @background;
            background: @blue;
            border-radius: 10px;
        }

        #workspaces button.focused {
            color: @background;
            background: @pink;
            border-radius: 10px;
        }

        #workspaces button.urgent {
            color: @background;
            background: @red;
            border-radius: 10px;
        }

        #workspaces button:hover {
            background: @background-alt;
            color: @foreground;
            border-radius: 10px;
        }

        #custom-language,
        #custom-updates,
        #custom-caffeine,
        #custom-weather,
        #window,
        #clock,
        #battery,
        #pulseaudio,
        #network,
        #cpu,
        #memory,
        #workspaces,
        #tray,
        #backlight {
            background: @background;
            padding: 0px 10px;
            margin: 3px 0px;
            margin-top: 10px;
            border: 1px solid @background-alt;
        }

        #tray {
            border-radius: 10px;
            margin-right: 10px;
        }

        #workspaces {
            background: @background;
            border-radius: 10px;
            margin-left: 10px;
            padding-right: 0px;
            padding-left: 5px;
        }

        #window {
            border-radius: 10px;
            margin-left: 60px;
            margin-right: 60px;
            color: @pink;
        }

        #clock {
            color: @orange;
            border-radius: 10px 0px 0px 10px;
            margin-left: 10px;
            border-right: 0px;
        }

        #network {
            color: @yellow;
            border-left: 0px;
            border-right: 0px;
        }

        #cpu {
            color: @green;
            border-left: 0px;
            border-right: 0px;
        }

        #memory {
            color: @cyan;
            border-left: 0px;
            border-right: 0px;
        }

        #pulseaudio {
            color: @blue;
            border-left: 0px;
            border-right: 0px;
        }

        #pulseaudio.microphone {
            color: @pink;
            border-left: 0px;
            border-right: 0px;
        }

        #battery {
            color: @green;
            border-radius: 0 10px 10px 0;
            margin-right: 10px;
            border-left: 0px;
        }

        #battery.charging {
            color: @green;
        }

        #battery.warning:not(.charging) {
            color: @yellow;
        }

        #battery.critical:not(.charging) {
            color: @red;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        @keyframes blink {
            to {
                background-color: @red;
                color: @background;
            }
        }

        #custom-weather {
            color: @cyan;
            border-radius: 0px 10px 10px 0px;
            border-left: 0px;
            margin-left: 0px;
        }

        #backlight {
            color: @yellow;
            border-left: 0px;
            border-right: 0px;
        }
      '';
      settings = {
        mainbar = {
          layer = "top";
          position = "top";
          mod = "dock";
          exclusive = true;
          passthrough = false;
          gtk-layer-shell = true;
          height = 0;
          modules-left = ["hyprland/workspaces" "hyprland/window"];
          modules-center = ["clock"];
          modules-right = [
            "cpu"
            "memory"
            "backlight"
            "pulseaudio"
            "network"
            "battery"
            "tray"
          ];

          "hyprland/window" = {
            format = "  {}";
            separate-outputs = true;
            max-length = 50;
          };

          "hyprland/workspaces" = {
            disable-scroll = false;
            all-outputs = true;
            on-click = "activate";
            format = "{icon}";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            format-icons = {
              "1" = "󰎤";
              "2" = "󰎧";
              "3" = "󰎪";
              "4" = "󰎭";
              "5" = "󰎱";
              "6" = "󰎳";
              "7" = "󰎶";
              "8" = "󰎹";
              "9" = "󰎼";
              "10" = "󰽽";
              "urgent" = "";
              "default" = "";
            };
            persistent-workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
            };
          };

          cpu = {
            interval = 10;
            format = "  {usage}%";
            max-length = 10;
          };

          memory = {
            interval = 30;
            format = "  {}%";
            max-length = 10;
          };

          backlight = {
            device = "intel_backlight";
            format = "{icon} {percent}%";
            format-icons = ["" "" "" "" "" "" "" "" ""];
            on-scroll-up = "brightnessctl set 5%+";
            on-scroll-down = "brightnessctl set 5%-";
          };

          tray = {
            icon-size = 16;
            spacing = 10;
          };

          clock = {
            format = "  {:%H:%M   %a %d %b}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          network = {
            format-wifi = "  {signalStrength}%";
            format-ethernet = "󰈀 {ipaddr}";
            format-disconnected = "󰖪 ";
            tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ipaddr}";
            tooltip-format-ethernet = "{ifname}\n{ipaddr}";
            on-click = "nm-connection-editor";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "󰝟 ";
            format-icons = {
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
            scroll-step = 5;
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󰂄 {capacity}%";
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            tooltip-format = "{timeTo}\n{capacity}%";
          };
        };
      };
    };

    programs.wofi = {
      enable = true;
      settings = {
        width = 600;
        height = 400;
        location = "center";
        show = "drun";
        prompt = "Search...";
        filter_rate = 100;
        allow_markup = true;
        no_actions = true;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = true;
        allow_images = true;
        image_size = 32;
        gtk_dark = true;
      };
      style = ''
        window {
            margin: 0px;
            border: 2px solid #7aa2f7;
            border-radius: 15px;
            background-color: #1a1b26;
            font-family: "JetBrainsMono Nerd Font";
            font-size: 14px;
        }

        #input {
            margin: 5px;
            border: none;
            border-radius: 10px;
            color: #c0caf5;
            background-color: #24283b;
        }

        #inner-box {
            margin: 5px;
            border: none;
            background-color: transparent;
        }

        #outer-box {
            margin: 5px;
            border: none;
            background-color: transparent;
        }

        #scroll {
            margin: 0px;
            border: none;
        }

        #text {
            margin: 5px;
            border: none;
            color: #c0caf5;
        }

        #entry {
            border-radius: 10px;
        }

        #entry:selected {
            background-color: #7aa2f7;
            color: #1a1b26;
        }

        #entry:selected #text {
            color: #1a1b26;
        }
      '';
    };

    home.packages = with pkgs; [
      grim
      slurp
      wf-recorder
      wl-mirror
      wl-clipboard
      clipman
      wlogout
      dunst
      libnotify
      qt6.qtwayland
      libsForQt5.qt5.qtwayland
      waypipe
      wtype
      ydotool
      pavucontrol
      networkmanagerapplet
      nautilus
    ];

    services.dunst = {
      enable = true;
      settings = {
        global = {
          font = "JetBrainsMono Nerd Font 11";
          frame_color = "#7aa2f7";
          separator_color = "frame";
          corner_radius = 10;
          background = "#1a1b26";
          foreground = "#c0caf5";
        };
        urgency_low = {
          background = "#1a1b26";
          foreground = "#c0caf5";
          frame_color = "#9ece6a";
        };
        urgency_normal = {
          background = "#1a1b26";
          foreground = "#c0caf5";
          frame_color = "#7aa2f7";
        };
        urgency_critical = {
          background = "#1a1b26";
          foreground = "#c0caf5";
          frame_color = "#f7768e";
        };
      };
    };
  };
}
