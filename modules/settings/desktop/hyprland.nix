{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    settings.desktop = {
      windowManager.hyprland = {
        enable = lib.mkEnableOption "Enable hyprland as windowManager";
        monitor = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = [ "eDP-1, 1920x1080@60, 0x0, 1" ];
        };
        workspaces = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
        };
      };
      screenLock.hypridle.enable = lib.mkEnableOption "Enables hypridle";
    };
  };
  config = {
    programs.hyprland = lib.mkIf config.settings.desktop.windowManager.hyprland.enable {
      enable = true;
      xwayland.enable = true;
    };
    services = {
      hypridle.enable = config.settings.desktop.screenLock.hypridle.enable;
    };

    # Home Manager as NixOS module
    home-manager.users.${config.settings.users.primary} =
      let
        nixos-config = config;
      in
      { config, inputs, ... }:
      {
        wayland.windowManager.hyprland =
          lib.mkIf nixos-config.settings.desktop.windowManager.hyprland.enable
            {
              enable = true;
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
                  "col.active_border" = "rgb(${config.colorScheme.palette.base05})";
                  "col.inactive_border" = "rgb(${config.colorScheme.palette.base02})";

                  layout = "dwindle";
                  allow_tearing = false;
                };

                monitor = lib.mkIf (
                  nixos-config.settings.desktop.windowManager.hyprland.monitor != null
                ) nixos-config.settings.desktop.windowManager.hyprland.monitor;

                workspace = lib.mkIf (
                  nixos-config.settings.desktop.windowManager.hyprland.workspaces != null
                ) nixos-config.settings.desktop.windowManager.hyprland.workspaces;

                plugin = {
                  hyprbars = {
                    bar_height = 30;
                    bar_title_enabled = false;
                    bar_part_of_window = false;
                    bar_precedence_over_border = false;
                    bar_color = "rgb(${config.colorScheme.palette.base00})";
                    bar_blur = true;
                    col.text = "rgb(${config.colorScheme.palette.base05})";
                    bar_padding = 10;
                    bar_button_padding = 15;
                    hyprbars-button = [
                      "rgb(${config.colorScheme.palette.base00}), 20,  , hyprctl dispatch killactive"
                      "rgb(${config.colorScheme.palette.base00}), 20,  , hyprctl dispatch fullscreen 1"
                      "rgb(${config.colorScheme.palette.base00}), 20,  , hyprctl dispatch togglefloating"
                      "rgb(${config.colorScheme.palette.base00}), 20, 󰋴 , resize_window.sh"

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
                  "$mod, E, exec, thunar"
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

                  "$mod SHIFT, N, exec, dunstctl history-pop"
                  "$mod, N, exec, dunstctl close"
                  "$mod CONTROL, N, exec, dunstctl close-all && dunstctl history-clear"

                  "$mod, Q, exec, grim -g \"$(slurp)\" - | swappy -f -"
                  # "$mod, Q, exec, screenshot_save.sh"
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
                  ",XF86MonBrightnessUp, exec, scr_light up"
                  ",XF86MonBrightnessDown, exec, scr_light down"
                  ",XF86AudioPlay, exec, playerctl play-pause"
                  ",XF86AudioPrev, exec, playerctl previous"
                  ",XF86AudioNext, exec, playerctl next"
                ];

                exec-once = "start-hyprland-env.sh";
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
            path = "/home/${nixos-config.settings.users.primary}/.config/wall/paper";
          };

          input-field = {
            monitor = "";
            size = "200, 50";
            outline_thickness = 3;
            dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8;
            dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0;
            dots_center = true;
            dots_rounding = -1;
            outer_color = "rgb(${config.colorScheme.palette.base00})";
            inner_color = "rgb(${config.colorScheme.palette.base05})";
            font_color = "rgb(${config.colorScheme.palette.base00})";
            fade_on_empty = true;
            fade_timeout = 1000;
            placeholder_text = "<i> Input Password...</i>";
            hide_input = false;
            rounding = -1; # -1 means complete rounding (circle/oval)
            check_color = "rgb(${config.colorScheme.palette.base0A})";
            fail_color = "rgb(${config.colorScheme.palette.base08})"; # if authentication failed, changes outer_color and fail message color
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
            border_color = "rgb(${config.colorScheme.palette.base05})";
            rotate = 0; # degrees, counter-clockwise
            reload_time = -1; # seconds between reloading, 0 to reload with SIGUSR2
            position = "0, 200";
            halign = "center";
            valign = "center";
          };
        };

        services.hypridle = lib.mkIf nixos-config.settings.desktop.screenLock.hypridle.enable {
          enable = true;
          settings = {
            general = {
              lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
              before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
              after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
            };

            listener = [
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
  };
}
