{
  pkgs,
  nixpkgs-stable,
  lib,
  ...
}@inputs:
let
  unstable-system-pkgs = with pkgs; [
    neovim
    tmux
    lf
    zsh
    zsh-syntax-highlighting
    starship
    git
    unzip
    tldr
    ripgrep
    fzf
    less
    man-db
    docker

    clang
    cmake
    meson
    rustup
    cpio
    pkg-config
    pyenv
    bc
    font-awesome
    psutils

    cups

    hyprlock
    hyprshade
    xdg-desktop-portal-hyprland
    waybar
    foot
    rofi-wayland
    swww
    dunst
    nwg-look
    whitesur-cursors
    bibata-cursors

    firefox

    upower

  ];
  stable-system-pkgs = with nixpkgs-stable.legacyPackages.${pkgs.system}; [
    auto-cpufreq
  ];

  unstable-user-pkgs = with pkgs; [
    discord
    virtualbox
    libreoffice-still
    arduino-ide
    freecad-wayland
    spotify
    orca-slicer
    remnote
    telegram-desktop
  ];

  stable-user-pkgs = with nixpkgs-stable.legacyPackages.${pkgs.system}; [ ];

  unstable-font-pkgs = with pkgs; [
    nerd-fonts.ubuntu-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  stable-font-pkgs = with nixpkgs-stable.legacyPackages.${pkgs.system}; [ ];

in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Instal system packages
  environment.systemPackages = lib.concatLists [
    unstable-system-pkgs
    stable-system-pkgs
  ];

  # Instal user packages
  users.users.falk.packages = lib.concatLists [
    unstable-user-pkgs
    stable-user-pkgs
  ];

  fonts.packages = lib.concatLists [
    unstable-font-pkgs
    stable-font-pkgs
  ];
}
