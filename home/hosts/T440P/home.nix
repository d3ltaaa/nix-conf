{
  inputs,
  config,
  lib,
  variables,
  ...
}:

{
  imports = [
    ./../../modules/default.nix
  ];

  programs.home-manager.enable = true;

  home.username = "${variables.user}";
  home.homeDirectory = "${variables.userHomeDir}";

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";
  home.sessionPath = [ ];

  # enable home-manager modules
  neovim-module.enable = true;
  foot-module.enable = true;
  git-module.enable = true;
  dunst-module.enable = true;
  lf-module.enable = true;
  hyprland-module.enable = true;
  rofi-module.enable = true;
  tmux-module.enable = true;
  waybar-module.enable = true;
  swappy-module.enable = true;
  zsh-module.enable = true;
  dconf-module.enable = true;
  userdirs-module.enable = true;
  theme-module.enable = true;

  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1, 1920x1080@60, 0x0, 1"
  ];
}
