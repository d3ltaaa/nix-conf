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
  foot-module.enable = false;
  git-module.enable = true;
  dunst-module.enable = false;
  lf-module.enable = true;
  hyprland-module.enable = false;
  rofi-module.enable = false;
  tmux-module.enable = true;
  waybar-module.enable = false;
  swappy-module.enable = false;
  zsh-module.enable = true;
  dconf-module.enable = true;
  userdirs-module.enable = false;
  theme-module.enable = true;
}
