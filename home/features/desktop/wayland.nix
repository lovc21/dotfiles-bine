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
            font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", "FiraCode Nerd Font";
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
        
        #language,
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
        #temperature,
        #disk,
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
            border-radius: 10px;
            margin-left: 0px;
            margin-right: 0px;
        }

        #custom-weather {
            color: @cyan;
            border-radius: 10px;
            margin-left: 10px;
        }

        #cpu {
            color: @green;
            border-radius: 10px 0px 0px 10px;
            border-right: 0px;
        }

        #memory {
            color: @cyan;
            border-left: 0px;
            border-right: 0px;
        }

        #temperature {
            color: @orange;
            border-left: 0px;
            border-right: 0px;
        }

        #disk {
            color: @purple;
            border-radius: 0px 10px 10px 0px;
            border-left: 0px;
            margin-right: 10px;
        }

        #backlight {
            color: @yellow;
            border-radius: 10px 0px 0px 10px;
            border-right: 0px;
        }

        #pulseaudio {
            color: @blue;
            border-left: 0px;
            border-right: 0px;
        }

        #pulseaudio.muted {
            color: @comment;
        }

        #network {
            color: @green;
            border-left: 0px;
            border-right: 0px;
        }

        #network.disconnected {
            color: @red;
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

        #language {
            color: @pink;
            border-radius: 10px;
            margin-left: 10px;
            margin-right: 5px;
        }

        @keyframes blink {
            to {
                background-color: @red;
                color: @background;
            }
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
          # --- FIXED: Moved clock to center, fixed weather position ---
          modules-left = ["custom/weather" "hyprland/workspaces" "hyprland/window"];
          modules-center = ["clock"];
          modules-right = [
            "hyprland/language"
            "cpu"
            "memory"
            "temperature"
            "disk"
            "backlight"
            "pulseaudio"
            "network"
            "battery"
            "tray"
          ];

          "hyprland/window" = {
            format = "  {}";
            separate-outputs = true;
            max-length = 30;
          };

          "hyprland/workspaces" = {
            disable-scroll = false;
            all-outputs = false;
            on-click = "activate";
            format = " {name} {icon} ";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "6" = "";
              "7" = "";
              "8" = "";
              "9" = "";
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

          "hyprland/language" = {
            format = " {}";
            format-english = "US";
            format-slovenian = "SI";
            on-click = "hyprctl switchxkblayout all next";
          };

          "custom/weather" = {
            format = "{}";
            tooltip = true;
            interval = 3600;
            exec = "curl -s 'https://wttr.in/Postojna?format=%C+%t'";
            return-type = ""; 
          };

          cpu = {
            interval = 5;
            format = "  {usage}%";
            max-length = 10;
            on-click = "ghostty -e htop";
          };

          memory = {
            interval = 10;
            format = "  {percentage}%";
            format-alt = "  {used:0.1f}G / {total:0.1f}G";
            max-length = 15;
            on-click = "ghostty -e htop";
          };

          temperature = {
            thermal-zone = 0;
            critical-threshold = 80;
            format = " {temperatureC}°C";
            format-critical = " {temperatureC}°C";
            interval = 5;
          };

          disk = {
            interval = 30;
            format = "  {percentage_used}%";
            format-alt = "  {used} / {total}";
            path = "/";
          };

          backlight = {
            device = "amdgpu_bl1";
            format = "{icon} {percent}%";
            format-icons = ["" "" "" "" "" "" "" "" ""];
            on-scroll-up = "brightnessctl set 5%+";
            on-scroll-down = "brightnessctl set 5%-";
          };

          tray = {
            icon-size = 16;
            spacing = 10;
          };

          clock = {
            format = "  {:%H:%M}";
            format-alt = "  {:%A, %B %d, %Y (%R)}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                months = "<span color='#c0caf5'><b>{}</b></span>";
                days = "<span color='#565f89'><b>{}</b></span>";
                weeks = "<span color='#7aa2f7'><b>W{}</b></span>";
                weekdays = "<span color='#ff9e64'><b>{}</b></span>";
                today = "<span color='#f7768e'><b><u>{}</u></b></span>";
              };
            };
          };

          network = {
            format-wifi = "  {signalStrength}%";
            format-ethernet = "󰈀 {ipaddr}";
            format-disconnected = "󰖪 ";
            format-alt = " {bandwidthDownBits}   {bandwidthUpBits}";
            tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ipaddr}\n {bandwidthDownBits}   {bandwidthUpBits}";
            tooltip-format-ethernet = "{ifname}\n{ipaddr}\n {bandwidthDownBits}   {bandwidthUpBits}";
            interval = 5;
            on-click-right = "nm-connection-editor";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "󰝟 ";
            format-icons = {
              headphone = " ";
              hands-free = " ";
              headset = " ";
              phone = " ";
              portable = " ";
              car = " ";
              default = [" " " " " "];
            };
            on-click = "pavucontrol";
            on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            scroll-step = 5;
          };

          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󱘖 {capacity}%";
            format-alt = "{icon} {time}";
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            tooltip-format = "{timeTo}\nCapacity: {capacity}%\nPower: {power}W";
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
      # Screenshot & Recording
      grim
      slurp
      wf-recorder
      wl-mirror
      
      # Clipboard
      wl-clipboard
      clipman
      
      # Utilities
      wlogout
      waypipe
      wtype
      ydotool
      
      # Notifications
      dunst
      libnotify
      
      # Qt Wayland support
      qt6.qtwayland
      libsForQt5.qt5.qtwayland
      
      # Audio
      pavucontrol
      
      # Network
      networkmanagerapplet
      
      # File manager
      nautilus
      
      # Weather - Kept just in case, but using curl now
      wttrbar
      
      # Brightness
      brightnessctl
    ];

    services.dunst = {
      enable = true;
      settings = {
        global = {
          width = 300;
          height = 100;
          offset = "30x50";
          origin = "top-right";
          transparency = 10;
          font = "JetBrainsMono Nerd Font 11";
          frame_color = "#7aa2f7";
          separator_color = "frame";
          corner_radius = 10;
          background = "#1a1b26";
          foreground = "#c0caf5";
          timeout = 5;
        };
        urgency_low = {
          background = "#1a1b26";
          foreground = "#c0caf5";
          frame_color = "#9ece6a";
          timeout = 3;
        };
        urgency_normal = {
          background = "#1a1b26";
          foreground = "#c0caf5";
          frame_color = "#7aa2f7";
          timeout = 5;
        };
        urgency_critical = {
          background = "#1a1b26";
          foreground = "#c0caf5";
          frame_color = "#f7768e";
          timeout = 0;
        };
      };
    };
  };
}
