{
  pkgs,
  nixpkgs-unstable,
  lib,
  scripts,
  config,
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
    lazygit
    fastfetch
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

    busybox
    dnsutils
    ethtool
    netcat-openbsd
  ];

  unstable-desk-pkgs = with pkgs; [
    waybar
    discord
    libreoffice-still
    arduino-ide
    freecad-wayland
    telegram-desktop
    orca-slicer
    rnote
    vlc
    remnote
    tor-browser-bundle-bin
  ];

  unstable-power-pkgs = with pkgs; [
    furmark
    powertop
    ncdu
    htop
    powerstat
    tlp
    stress-ng
    auto-cpufreq
  ];

  unstable-system-pkgs = with pkgs; [
  ];

  stable-system-pkgs = with nixpkgs-unstable; [
  ];

  unstable-user-pkgs = with pkgs; [
  ];

  stable-user-pkgs = with nixpkgs-unstable; [ ];

  unstable-font-pkgs = with pkgs; [
    nerd-fonts.ubuntu-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  stable-font-pkgs = with nixpkgs-unstable; [ ];

  # derivations
  my-scripts = import ./derivations/scripts.nix { inherit pkgs scripts; };
  derivations = [ my-scripts ]; # add to list

  flatpak-pkgs = [
    "io.emeric.toolblex"
    "com.obsproject.Studio"
    "net.mkiol.SpeechNote"
    "app.zen_browser.zen"
    "org.bleachbit.BleachBit"
    "com.borgbase.Vorta" # Vorta backups
  ];

in
{
  options = {
    applications.packages.libraries = {
      unstable = {
        system = {
          default = lib.mkEnableOption "Enables unstable-system-pkgs";
          base = lib.mkEnableOption "Enables unstable-base-pkgs";
          lang = lib.mkEnableOption "Enables unstable-lang-pkgs";
          tool = lib.mkEnableOption "Enables unstable-tool-pkgs";
          hypr = lib.mkEnableOption "Enables unstable-hypr-pkgs";
          desk = lib.mkEnableOption "Enables unstable-desk-pkgs";
          power = lib.mkEnableOption "Enables unstable-power-pkgs";
        };
        user.default = lib.mkEnableOption "Enables unstable-user-pkgs";
        font.default = lib.mkEnableOption "Enables unstable-font-pkgs";
      };
      stable = {
        system.default = lib.mkEnableOption "Enables stable-system-pkgs";
        user.default = lib.mkEnableOption "Enables stable-user-pkgs";
        font.default = lib.mkEnableOption "Enables stable-font-pkgs";
      };
      flatpaks.default = lib.mkEnableOption "Enables Flatpaks";
      derivations.default = lib.mkEnableOption "Enables derivations";
    };
  };

  config = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Install system packages
    environment.systemPackages =
      [ ]
      ++ (pkgs.lib.optionals config.applications.packages.libraries.stable.system.default stable-system-pkgs)
      ++ (pkgs.lib.optionals config.applications.packages.libraries.unstable.system.default unstable-system-pkgs)
      ++ (pkgs.lib.optionals config.applications.packages.libraries.unstable.system.base unstable-base-pkgs)
      ++ (pkgs.lib.optionals config.applications.packages.libraries.unstable.system.lang unstable-lang-pkgs)
      ++ (pkgs.lib.optionals config.applications.packages.libraries.unstable.system.tool unstable-tool-pkgs)
      ++ (pkgs.lib.optionals config.applications.packages.libraries.unstable.system.hypr unstable-hypr-pkgs)
      ++ (pkgs.lib.optionals config.applications.packages.libraries.unstable.system.desk unstable-desk-pkgs)
      ++ (pkgs.lib.optionals config.applications.packages.libraries.unstable.system.power unstable-power-pkgs)
      ++ (pkgs.lib.optionals config.applications.packages.libraries.derivations.default derivations);

    # Install user packages
    users.users.${config.settings.users.primary}.packages =
      [ ]
      ++ (pkgs.lib.optionals config.applications.packages.libraries.stable.user.default stable-user-pkgs)
      ++ (pkgs.lib.optionals config.applications.packages.libraries.unstable.user.default unstable-user-pkgs);
    # Install font packages
    fonts.packages =
      [ ]
      ++ (pkgs.lib.optionals config.applications.packages.libraries.stable.font.default stable-font-pkgs)
      ++ (pkgs.lib.optionals config.applications.packages.libraries.unstable.font.default unstable-font-pkgs);

    # has to be enabled in order for flatpaks to work!
    xdg.portal = lib.mkIf config.applications.packages.libraries.flatpaks.default {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };
    services.flatpak = lib.mkIf config.applications.packages.libraries.flatpaks.default {
      enable = true;
      remotes = lib.mkOptionDefault [
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];
      update.auto.enable = false;
      uninstallUnmanaged = true;

      # Add here the flatpaks you want to install
      packages = flatpak-pkgs;
    };
  };
}
