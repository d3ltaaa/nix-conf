{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    monitor = [
      "eDP-1, 1920x1080@60, 0x0, 1"
    ];
  };
}
