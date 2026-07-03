{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.wayland;
in
{
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

        #custom-language,
        #custom-updates,
        #custom-caffeine,
        #custom-weather,
        #custom-aibar,
        #custom-spotify,
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
            margin-right: 15px;
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

        #custom-aibar {
            color: @purple;
            border-radius: 10px;
            margin-left: 10px;
            margin-right: 5px;
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

        #custom-language {
            color: @pink;
            border-radius: 10px;
            margin-right: 5px;
        }

        #custom-spotify {
            color: @green;
            border-radius: 10px;
            margin-left: 10px;
        }

        #custom-spotify.paused {
            color: @comment;
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
          mode = "dock";
          exclusive = true;
          passthrough = false;
          gtk-layer-shell = true;
          height = 30;
          modules-left = [
            "custom/weather"
            "hyprland/workspaces"
            "custom/spotify"
          ];
          modules-center = [
            "custom/language"
            "clock"
          ];
          modules-right = [
            "custom/aibar"
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
            format-empty = "";
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
              "1" = [ ];
              "2" = [ ];
              "3" = [ ];
              "4" = [ ];
              "5" = [ ];
            };
          };

          "custom/spotify" = {
            exec = "${pkgs.writeShellScript "waybar-spotify" ''
              ${pkgs.playerctl}/bin/playerctl -p spotify --follow metadata \
                --format '{"text":"  {{markup_escape(title)}} — {{markup_escape(artist)}}","tooltip":"{{markup_escape(title)}}\n{{markup_escape(artist)}}\n{{markup_escape(album)}}","class":"{{lc(status)}}"}' \
                2>/dev/null
            ''}";
            return-type = "json";
            restart-interval = 5;
            max-length = 45;
            on-click = "${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
            on-scroll-up = "${pkgs.playerctl}/bin/playerctl -p spotify next";
            on-scroll-down = "${pkgs.playerctl}/bin/playerctl -p spotify previous";
            on-click-right = "spotify";
          };

          "custom/language" = {
            exec = "${pkgs.writeShellScript "waybar-language" ''
              layout=$(${pkgs.hyprland}/bin/hyprctl -j devices \
                | ${pkgs.jq}/bin/jq -r '.keyboards[] | select(.main==true) | .active_keymap')
              case "$layout" in
                *Sloven*) echo "SI" ;;
                *English*) echo "EN" ;;
                *) echo "''${layout:0:2}" ;;
              esac
            ''}";
            interval = 60;
            signal = 8;
            on-click = "hyprctl switchxkblayout all next && pkill -RTMIN+8 waybar";
          };

          "custom/weather" = {
            format = "{}";
            tooltip = true;
            interval = 3600;
            exec = ''
              LOC=$(curl -s https://ipinfo.io/json)
              CITY=$(echo $LOC | jq -r '.city')
              COUNTRY=$(echo $LOC | jq -r '.country')
              curl -s "https://wttr.in/$CITY?format=%c+%C,+%t,+$CITY+$COUNTRY" | sed 's/+//'
            '';
            return-type = "";
          };

          "custom/aibar" = {
            exec = "${pkgs.ai-usagebar}/bin/ai-usagebar --format '{vendor_short} {session_pct}%'";
            return-type = "json";
            interval = 300;
            tooltip = true;
            on-click = "ghostty -e ${pkgs.ai-usagebar}/bin/ai-usagebar-tui";
            on-scroll-up = "${pkgs.ai-usagebar}/bin/ai-usagebar --cycle-next";
            on-scroll-down = "${pkgs.ai-usagebar}/bin/ai-usagebar --cycle-prev";
          };

          cpu = {
            interval = 5;
            format = " {usage}%";
            max-length = 10;
            on-click = "ghostty -e htop";
          };

          memory = {
            interval = 10;
            format = " {percentage}%";
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
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
            on-scroll-up = "brightnessctl set 5%+";
            on-scroll-down = "brightnessctl set 5%-";
          };

          tray = {
            icon-size = 14;
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
            on-click-right = "networkmanager_dmenu";
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
              default = [
                " "
                " "
                " "
              ];
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
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
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
    };

    home.packages = with pkgs; [
      # AI usage bar (waybar widget + TUI)
      ai-usagebar

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
      qt5.qtwayland

      # Audio
      pavucontrol

      # Network
      networkmanagerapplet
      networkmanager_dmenu

      # File manager
      nautilus

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
          corner_radius = 10;
          timeout = 5;
        };
        urgency_low.timeout = 3;
        urgency_normal.timeout = 5;
        urgency_critical.timeout = 0;
      };
    };

    xdg.configFile."networkmanager-dmenu/config.ini".text = ''
      [dmenu]
      dmenu_command = wofi --dmenu --prompt "Wi-Fi"
    '';
  };
}
