{ ... }:
{

  programs.waybar.enable = true;
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      spacing = 0;
      height = 41;

      modules-left = [
        "custom/logo"
        "hyprland/workspaces"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "tray"
        "network"
        "pulseaudio"
        "custom/idle"
        "custom/appmenu"
        "custom/system_stats"
        "custom/settings"
        "custom/power"
      ];

      "wlr/taskbar" = {
        format = " { icon }";
        on-click = "activate";
        on-click-right = "fullscreen";
        icon-theme = "WhiteSur";
        icon-size = 25;
        tooltip-format = "{title}";
      };

      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          default = "";
          "1" = 1;
          "2" = 2;
          "3" = 3;
          "4" = 4;
          "5" = 5;
          "6" = 6;
          "7" = 7;
          "8" = 8;
          "9" = 9;
          urgent = "󱓻";
        };
        persistent_workspaces = { };
      };

      tray = {
        spacing = 1;
      };

      clock = {
        tooltip-format = "<tt>{calendar}</tt>";
        format = "{:%H:%M     %d.%m.%Y}";
      };

      network = {
        format-wifi = "{icon}";
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format-ethernet = "󰀂";
        format-alt = "󱛇";
        format-disconnected = "󰖪";
        tooltip-format-wifi = "{icon} {essid}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-ethernet = "󰀂  {ifname}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        on-click = "~/.config/rofi/ &";
        on-click-right = "~/.config/rofi/ &";
        interval = 5;
        nospacing = 1;
      };

      pulseaudio = {
        format = "{icon}";
        format-bluetooth = "󰂰";
        nospacing = 1;
        tooltip-format = "Volume : {volume}%";
        format-muted = "󰝟";
        format-icons = {
          headphone = "";
          default = [
            "󰖀"
            "󰕾"
            ""
          ];
        };
        on-click = "pulsemixer --toggle-mute";
        scroll-step = 5;
      };

      battery = {
        format = "{capacity}% {icon}";
        format-icons = {
          charging = [
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
          default = [
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
        };
        format-full = "Charged ";
        interval = 5;
        states = {
          warning = 20;
          critical = 10;
        };
        tooltip = false;
      };

      "custom/appmenu" = {
        format = "";
        tooltip = false;
        on-click = "sleep 0.1; rofi -show drun -case-insensitive";
      };

      "custom/idle" = {
        interval = "once";
        signal = "6";
        format = "{}";
        tooltip = false;
        on-click = "toggle_hypridle.sh";
        exec = "hypridle_icon.sh";
        return-type = "json";
      };

      cpu = {
        interval = 10;
        format = "{}% ";
        max-length = 10;
      };

      "custom/system_stats" = {
        interval = 2;
        format = "{}";
        on-click = "menu_options energy";
        return-type = "json";
        exec = "get_system_stats.sh";
      };

      memory = {
        interval = 30;
        format = "{used:0.1f}G/{total:0.1f}G ";
      };

      temperature = {
        # "thermal-zone"= 2;
        # "hwmon-path"= "/sys/class/hwmon/hwmon2/temp1_input";
        # "critical-threshold"= 80;
        # "format-critical"= "{temperatureC}°C ";
        format = "{temperatureC}°C ";
      };

      "custom/settings" = {
        format = "";
        tooltip = false;
        on-click = "sleep 0.1; menu_options";
      };

      "custom/power" = {
        format = "󰤆";
        tooltip = false;
        on-click = "sleep 0.1; menu_system";
      };

    };
  };
  programs.waybar.style = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      font-family: Font Awesome Icons, Material Design Icons, JetBrainsMono Nerd Font;
      font-size: 13px;
    }

    window#waybar {
      background-color: transparent;
      transition-property: background-color;
      transition-duration: 0.2s;
    }

    window#waybar.hidden {
      opacity: 0.5;
    }

    #workspaces {
      background-color: transparent;
    }

    #workspaces button {
      all: initial; /* Remove GTK theme values (waybar #1351) */
      min-width: 0; /* Fix weird spacing in materia (waybar #450) */
      box-shadow: inset 0 -3px transparent; /* Use box-shadow instead of border so the text isn't offset */
      padding: 6px 18px;
      margin: 6px 3px;
      border-radius: 4px;
      background-color: #1e1e2e;
      color: #cdd6f4;
    }

    #workspaces button.active {
      color: #1e1e2e;
      background-color: #ffffff;
    }

    #workspaces button:hover {
     box-shadow: inherit;
     text-shadow: inherit;
     color: #1e1e2e;
     background-color: #ffffff;
    }

    #workspaces button.urgent {
      background-color: #ffffff;
    }

    #custom-system_stats,
    #cpu,
    #custom-test,
    #memory,
    #temperature,
    #custom-power,
    #custom-idle,
    #battery,
    #backlight,
    #pulseaudio,
    #network,
    #clock,
    #custom-settings,
    #custom-appmenu,
    #custom-logo {
      border-radius: 4px;
      margin: 6px 3px;
      padding: 6px 12px;
      background-color: #1e1e2e;
      color: #181825;
    }

    #custom-power {
      margin-right: 6px;
    }

    #temperature,
    #cpu,
    #memory {
      background-color: #ffffff;
    }

    #battery {
      background-color: #ffffff;
    }

    @keyframes blink {
      to {
        background-color: #ffffff;
        color: #181825;
      }
    }

    #battery.warning,
    #battery.critical,
    #battery.urgent {
      background-color: #ffffff;
      color: #181825;
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }
    #battery.charging {
      background-color: #ffffff;
    }

    #backlight {
      background-color: #ffffff;
    }

    #pulseaudio {
      background-color: #ffffff;
    }

    #custom-idle {
      background-color: #ffffff;
    }

    #network {
      background-color: #ffffff;
      padding-right: 17px;
    }

    #clock {
      font-family: JetBrainsMono Nerd Font;
      background-color: #ffffff;
    }


    #custom-power {
      background-color: #ffffff;
    }

    #tray {
      border-radius: 4px;
      margin: 6px 3px;
      padding: 6px 12px;
      background-color: #1e1e2e;
      color: #181825;
    }

    #custom-settings {
      background-color: #ffffff;
    }

    #custom-system_stats,
    #custom-appmenu {
      background-color: #ffffff;
    }


    tooltip {
    border-radius: 8px;
    padding: 15px;
    background-color: #1e1e2e;
    }

    tooltip label {
    padding: 5px;
    background-color: #1e1e2e;
    }
  '';

}
