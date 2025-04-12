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
    wget
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

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "";
        CPU_SCALING_GOVERNOR_ON_BAT = "";

        CPU_ENERGY_PERF_POLICY_ON_AC = "";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "";

        PLATFORM_PROFILE_ON_AC = "";
        PLATFORM_PROFILE_ON_BAT = "";

        PCIE_ASPM_ON_AC = "performance";
        PCIE_ASPM_ON_BAT = "powersupersave";

        DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth nfc wwan";
        DEVICES_TO_DISABLE_ON_SHUTDOWN = "bluetooth nfc wifi wwan";
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth nfc wifi wwan";

        DEVICES_TO_DISABLE_ON_WIFI_CONNECT = "wwan";
        DEVICES_TO_DISABLE_ON_WWAN_CONNECT = "wifi";

        # CPU_SCALING_GOVERNOR_ON_AC = "performance";
        # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        #
        # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        #
        # PLATFORM_PROFILE_ON_AC = "performance";
        # PLATFORM_PROFILE_ON_BAT = "low-power";
        #
        # CPU_BOOST_ON_AC = 1;
        # CPU_BOOST_ON_BAT = 1;
        #
        # CPU_HWP_DYN_BOOST_ON_AC = 1;
        # CPU_HWP_DYN_BOOST_ON_BAT = 1;

        #CPU_MIN_PERF_ON_AC = 0;
        #CPU_MAX_PERF_ON_AC = 100;
        #CPU_MIN_PERF_ON_BAT = 0;
        #CPU_MAX_PERF_ON_BAT = 20;

        #Optional helps save long term battery health
        # START_CHARGE_THRESH_BAT0 = 60; # 60 and below it starts to charge
        # STOP_CHARGE_THRESH_BAT0 = 90; # 90 and above it stops charging

      };
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
