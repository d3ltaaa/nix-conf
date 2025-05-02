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
  unstable-base-pkgs = with pkgs; [
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
  ];

  unstable-lang-pkgs = with pkgs; [
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
  ];

  unstable-hypr-pkgs = with pkgs; [
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
  ];

  unstable-tool-pkgs = with pkgs; [
    mpv
    yt-dlg

    sox # ?
    ffmpeg_4 # ?

    android-tools

    upower
    pulsemixer
    libpulseaudio
    pavucontrol
  ];

  unstable-desk-pkgs = with pkgs; [
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
  ];

  unstable-power-pkgs = with pkgs; [
    furmark
    powertop
    ncdu
    htop
    powerstat
    tlp
    stress-ng
  ];

  unstable-system-pkgs = with pkgs; [
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
    packages-module = {
      enable = lib.mkEnableOption "Enables Packages module";
      system = {
        stable = lib.mkEnableOption "Enables stable-system-pkgs";
        unstable = lib.mkEnableOption "Enables unstable-system-pkgs";
        unstable-base = lib.mkEnableOption "Enables unstable-base-pkgs";
        unstable-lang = lib.mkEnableOption "Enables unstable-lang-pkgs";
        unstable-tool = lib.mkEnableOption "Enables unstable-tool-pkgs";
        unstable-hypr = lib.mkEnableOption "Enables unstable-hypr-pkgs";
        unstable-desk = lib.mkEnableOption "Enables unstable-desk-pkgs";
        unstable-power = lib.mkEnableOption "Enables unstable-power-pkgs";
        derivations = lib.mkEnableOption "Enables derivations";
      };

      user = {
        stable = lib.mkEnableOption "Enables stable-user-pkgs";
        unstable = lib.mkEnableOption "Enables unstable-user-pkgs";
      };
      fonts = {
        stable = lib.mkEnableOption "Enables stable-font-pkgs";
        unstable = lib.mkEnableOption "Enables unstable-font-pkgs";
      };
    };
  };

  config = lib.mkIf config.packages-module.enable {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Install system packages
    environment.systemPackages =
      [ ]
      ++ (pkgs.lib.optionals config.packages-module.system.stable stable-system-pkgs)
      ++ (pkgs.lib.optionals config.packages-module.system.unstable unstable-system-pkgs)
      ++ (pkgs.lib.optionals config.packages-module.system.unstable-base unstable-base-pkgs)
      ++ (pkgs.lib.optionals config.packages-module.system.unstable-lang unstable-lang-pkgs)
      ++ (pkgs.lib.optionals config.packages-module.system.unstable-tool unstable-tool-pkgs)
      ++ (pkgs.lib.optionals config.packages-module.system.unstable-hypr unstable-hypr-pkgs)
      ++ (pkgs.lib.optionals config.packages-module.system.unstable-desk unstable-desk-pkgs)
      ++ (pkgs.lib.optionals config.packages-module.system.unstable-power unstable-power-pkgs)
      ++ (pkgs.lib.optionals config.packages-module.system.derivations derivations);

    # Install user packages
    users.users.${variables.user}.packages =
      [ ]
      ++ (pkgs.lib.optionals config.packages-module.user.stable stable-user-pkgs)
      ++ (pkgs.lib.optionals config.packages-module.user.unstable unstable-user-pkgs);
    # Install font packages
    fonts.packages =
      [ ]
      ++ (pkgs.lib.optionals config.packages-module.fonts.stable stable-font-pkgs)
      ++ (pkgs.lib.optionals config.packages-module.fonts.unstable unstable-font-pkgs);
  };
}
