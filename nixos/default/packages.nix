{
  pkgs,
  nixpkgs-stable,
  lib,
  scripts,
  config,
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

    upower
    pulsemixer

    firefox
    protonmail-desktop
    waybar
    discord
    libreoffice-still
    arduino-ide
    freecad-wayland
    spotify
    orca-slicer
    remnote
    telegram-desktop

    furmark
    powertop
    ncdu
    htop
    powerstat
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
  my-scripts = import ./../derivations/scripts.nix { inherit pkgs scripts; };
  derivations = [ my-scripts ]; # add to list

in
{

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Instal system packages
  environment.systemPackages = lib.concatLists [
    unstable-system-pkgs
    stable-system-pkgs
    derivations
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
    hyprland.enable = true;
    hyprlock.enable = true;
    hyprland.xwayland.enable = true;
    zsh.enable = true;
    thunar.enable = true;
    dconf.enable = true;
    git = {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "manager";
      config.credential."https://github.com".username = "falk";
      config.credential.credentialstore = "cache";
    };
  };

  # List services that you want to enable:
  services = {
    upower.enable = true;
    udisks2.enable = true;
    printing.enable = true;
    hypridle.enable = true;
    syncthing = {
      enable = true;
      dataDir = "/home/falk";
      user = "falk";
    };

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          energy_performance_bias = "power";
          energy_performance_preference = "power";
          turbo = "auto";
          enable_thresholds = true;
          start_threshold = 90;
          stop_threshold = 95;
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
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
