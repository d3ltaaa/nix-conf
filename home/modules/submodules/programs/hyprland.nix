{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    hyprland-module.enable = lib.mkEnableOption "Enables Hyprland module";
  };

  config = lib.mkIf config.hyprland-module.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      systemd.enable = true;
      settings = {

        env = [
          "_JAVA_AWT_WM_NONREPARENTING,1"
          "XCURSOR_SIZE,24"
          "XCURSOR_THEME, Bibata-Modern-Ice"
          "WLR_NO_HARDWARE_CURSORS,1"
        ];

        input = {
          kb_layout = "de";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = "no";
          };
        };

        general = {
          gaps_in = 10;
          gaps_out = 20;
          border_size = 4;
          "col.active_border" = "rgba(ffffffff)";
          "col.inactive_border" = "rgba(595959aa)";

          layout = "dwindle";
          allow_tearing = false;
        };

        plugin = {
          hyprbars = {
            bar_height = 30;
            bar_title_enabled = false;
            bar_part_of_window = false;
            bar_precedence_over_border = false;
            bar_color = "rgb(1e1e2e)";
            bar_blur = true;
            col.text = "rgb(ffffff)";
            bar_padding = 10;
            bar_button_padding = 15;
            hyprbars-button = [
              "rgb(1e1e2e), 20,  , hyprctl dispatch killactive"
              "rgb(1e1e2e), 20,  , hyprctl dispatch fullscreen 1"
              "rgb(1e1e2e), 20,  , hyprctl dispatch togglefloating"
              "rgb(1e1e2e), 20, 󰋴 , resize_window.sh"

            ];
          };
        };

        animations = {
          enabled = "yes";

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 1, myBezier, popin 100%"
            "windowsOut, 1, 1, default, popin 100%"
            "border, 1, 1, default"
            "borderangle, 1, 1, default"
            "fade, 1, 1, default"
            "workspaces, 1, 1, default"

          ];
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 5;
            passes = 2;
          };
          # windowrule = "opacity 0.9, foot";
        };

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
        };

        gestures = {
          workspace_swipe = "on";
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          enable_swallow = true;
          swallow_regex = "^(kitty|alacritty)$";
        };

        "$mod" = "SUPER";
        bind = [

          "$mod SHIFT, RETURN, exec, foot"
          "$mod, X, killactive, "
          "$mod, M, exit,"
          "$mod, T, togglefloating,"
          "$mod, F, fullscreen,"
          "$mod, SPACE, exec, rofi -show drun -case-insensitive"
          "$mod, P, pseudo"
          "$mod, U, togglesplit"
          "$mod SHIFT, W, exec, pkill waybar; waybar"

          "$mod, L, movefocus, r"
          "$mod, H, movefocus, l"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          "$mod CONTROLALT, L, swapwindow, r"
          "$mod CONTROLALT, H, swapwindow, l"
          "$mod CONTROLALT, K, swapwindow, u"
          "$mod CONTROLALT, J, swapwindow, d"

          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, J, movewindow, d"

          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"

          "$mod CONTROL, S, togglespecialworkspace, magic"
          "$mod CONTROL SHIFT, S, movetoworkspace, special:magic"

          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          "$mod CONTROL, L, resizeactive, 40 0"
          "$mod CONTROL, H, resizeactive, -40 0"
          "$mod CONTROL, K, resizeactive, 0 -40"
          "$mod CONTROL, J, resizeactive, 0 40"
          "$mod, S, exec, menu_options &"
          "$mod SHIFT, S, exec, menu_system &"
          ",F86AudioMicMute, exec, rofi"
          ",F86AudioPlay, exec, playerctl play-pause"
          ",F86AudioPrev, exec, playerctl previous"
          ",F86AudioNext, exec, playerctl next"

          "$mod SHIFT, N, exec, dunstctl history-pop"
          "$mod, N, exec, dunstctl close"
          "$mod CONTROL, N, exec, dunstctl close-all && dunstctl history-clear"

          "$mod, Q, exec, grim -g $(slurp) - | swappy -f -"
          "$mod, G, exec, hyprlock"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"

        ];

        binde = [
          ",XF86AudioMute, exec, scr_volume mute"
          ",XF86AudioLowerVolume, exec, scr_volume dec"
          ",XF86AudioRaiseVolume, exec, scr_volume inc"
          ",XF86MonBrightnessUp, exec, brillo -A 10"
          ",XF86MonBrightnessDown, exec, brillo -U 10"
        ];

        monitor = lib.mkDefault [
          "eDP-1, 1920x1080@60, 0x0, 1"
        ];

        exec-once = [
          "hyprlock &"
          "swww-daemon &"
          "swww img ~/.config/wall/selected* &"
          "hyprpm reload -n"
          "waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &"
        ];
        # exec-once = "hyprlock & && swww-daemon & && swww img ~/.config/wall/selected* && hyprpm reload -n && waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &;";
        # exec-once = "~/.config/start.sh";

      };

      plugins = [
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
        pkgs.hyprlandPlugins.hyprbars
      ];
    };

    programs.hyprlock.enable = true;
    programs.hyprlock.settings = {
      background = {
        monitor = "";
        path = "/home/falk/.config/wall/paper";
      };

      input-field = {
        monitor = "";
        size = "200, 50";
        outline_thickness = 3;
        dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8;
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0;
        dots_center = true;
        dots_rounding = -1;
        outer_color = "rgb(151515)";
        inner_color = "rgb(FFFFFF)";
        font_color = "rgb(10, 10, 10)";
        fade_on_empty = true;
        fade_timeout = 1000;
        placeholder_text = "<i> Input Password...</i>";
        hide_input = false;
        rounding = -1; # -1 means complete rounding (circle/oval)
        check_color = "rgb(204, 136, 34)";
        fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
        fail_transition = 300; # transition time in ms between normal outer_color and fail_color
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false; # change color if numlock is off
        swap_font_color = false; # see below
        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      image = {
        monitor = "";
        path = "$HOME/.cache/square_wallpaper.png";
        size = 280; # lesser side if not 1:1 ratio
        rounding = -1; # negative values mean circle
        border_size = 4;
        border_color = "rgb(221, 221, 221)";
        rotate = 0; # degrees, counter-clockwise
        reload_time = -1; # seconds between reloading, 0 to reload with SIGUSR2
        position = "0, 200";
        halign = "center";
        valign = "center";
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 100; # 2.5min.
            on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r"; # monitor backlight restore.
          }
          # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          {
            timeout = 100; # 2.5min.
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
            on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
          }

          {
            timeout = 200; # 5min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }

          {
            timeout = 260; # 5.5min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on && brightnessctl -r"; # screen on when activity is detected after timeout has fired.
          }

          {
            timeout = 300; # 30min
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
    };
  };
}
