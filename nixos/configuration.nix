# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }@inputs:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./auto-login.nix
  ];
  # enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "NIX-FH"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable blutooth
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  environment.variables = {
    EDITOR = "nvim";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    WLR_RENDERER_ALLOW_SOFTWARE = 1;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.falk = {
    isNormalUser = true;
    description = "Falk";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
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
    discord
    virtualbox
    libreoffice-still
    arduino-ide
    freecad-wayland
    spotify
    orca-slicer
    remnote
    telegram-desktop

    auto-cpufreq
    upower
  ];

  programs.dconf.enable = true;
  programs.hyprlock.enable = true;
  programs.zsh.enable = true;
  programs.thunar.enable = true;

  programs.hyprland.enable = true;
  # wayland.windowManager.hyprland.plugins = [
  #   pkgs.hyprlandPlugin.hyprbars
  # ];

  fonts.packages = [
    pkgs.nerd-fonts.ubuntu-mono
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.hack
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.upower.enable = true;
  services.udisks2.enable = true;
  services.printing.enable = true;
  services.auto-cpufreq.enable = true;
  services.syncthing.enable = true;
  services.auto-cpufreq.settings = {
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
  programs.neovim.defaultEditor = true;

  security.sudo.extraConfig = "Defaults        !sudoedit_checkdir";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
