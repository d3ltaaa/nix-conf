{
  inputs,
  config,
  lib,
  user,
  userHomeDir,
  ...
}:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.catppuccin.homeModules.catppuccin
    ./../../modules/programs.nix
    ./../../modules/theme.nix
    ./../../modules/userdirs.nix
    ./../../modules/dconf.nix
  ];

  programs.home-manager.enable = true;

  home.username = "${user}";
  home.homeDirectory = "${userHomeDir}";

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
  zsh-module.enable = true;
  dconf-module.enable = true;
  userdirs-module.enable = true;
  theme-module.enable = true;

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-3, 2560x1440@240, 0x0, 1"
    "DP-2, 1920x1080@165, 2560x0, 1"
  ];

  wayland.windowManager.hyprland.settings.workspace = [
    "1, monitor:DP-3"
    "3, monitor:DP-3"
    "5, monitor:DP-3"
    "7, monitor:DP-3"
    "9, monitor:DP-3"
    "2, monitor:DP-2"
    "4, monitor:DP-2"
    "6, monitor:DP-2"
    "8, monitor:DP-2"
  ];
}
