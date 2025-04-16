{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    monitor = [
      "DP-3, 2560x1440@240, 0x0, 1"
      "DP-2, 1920x1080@165, 2560x0, 1"
    ];
  };
}
