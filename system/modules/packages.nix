{
  pkgs,
  nixpkgs-stable,
  lib,
  scripts,
  config,
  variables,
  ...
}@inputs:
let
  unstable-system-pkgs = with pkgs; [
    wget
    lf
    unzip
    tldr
    ripgrep
    rsync
    fzf
    man-db
    docker
    zsh
    zsh-syntax-highlighting
    starship
    git-credential-manager

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

    slurp
    feh
    grim
    swappy

    zathura
    pandoc

    mpv
    yt-dlg

    sox # ?
    ffmpeg_4 # ?

    android-tools

    upower
    pulsemixer
    libpulseaudio
    pavucontrol

    firefox
    protonmail-desktop
    waybar
    discord
    libreoffice-still
    arduino-ide
    freecad-wayland
    spotify
    orca-slicer
    # remnote
    telegram-desktop

    furmark
    powertop
    ncdu
    htop
    powerstat
    tlp
    stress-ng
  ];
  stable-system-pkgs = with nixpkgs-stable.legacyPackages.${pkgs.system}; [
    auto-cpufreq
  ];

  unstable-user-pkgs = with pkgs; [
  ];

  stable-user-pkgs = with nixpkgs-stable.legacyPackages.${pkgs.system}; [ ];

  unstable-font-pkgs = with pkgs; [
    nerd-fonts.ubuntu-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  stable-font-pkgs = with nixpkgs-stable.legacyPackages.${pkgs.system}; [ ];

  # derivations
  my-scripts = import ./submodules/derivations/scripts.nix { inherit pkgs scripts; };
  derivations = [ my-scripts ]; # add to list

in
{
  options = {
    packages-module.enable = lib.mkEnableOption "Enables Packages module";
  };
  config = lib.mkIf config.packages-module.enable {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Install system packages
    environment.systemPackages = lib.concatLists [
      unstable-system-pkgs
      stable-system-pkgs
      derivations
    ];

    # Install user packages
    users.users.${variables.user}.packages = lib.concatLists [
      unstable-user-pkgs
      stable-user-pkgs
    ];

    fonts.packages = lib.concatLists [
      unstable-font-pkgs
      stable-font-pkgs
    ];
  };
}
