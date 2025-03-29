{
  pkgs,
  nixpkgs-stable,
  lib,
  ...
}@inputs:
let
  unstable-system-pkgs = with pkgs; [
    lf
    unzip
    tldr
    ripgrep
    fzf
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

    hyprshade
    xdg-desktop-portal-hyprland
    rofi-wayland
    swww
    dunst
    nwg-look
    whitesur-cursors
    bibata-cursors

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

  programs = {
    firefox.enable = true;
    less.enable = true;
    thunar.enable = true;
    dconf.enable = true;
    zsh.enable = true;
  };

  # List services that you want to enable:
  services = {
    upower.enable = true;
    udisks2.enable = true;
    printing.enable = true;
    auto-cpufreq.enable = true;
    syncthing.enable = true;

    auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
        enable_thresholds = true;
        start_threshold = 70;
        stop_threshold = 95;
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };

    # Configure keymap in X11
    xserver.xkb = {
      layout = "de";
      variant = "";
    };

    getty = {
      autologinOnce = true;
      autologinUser = "falk";
      # loginProgram = "${pkgs.shadow}/bin/hyprland";
    };
  };
}
