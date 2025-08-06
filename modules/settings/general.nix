{
  config,
  lib,
  ...
}@inputs:
{
  options = {
    settings.general = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "NIXOS";
      };
      nixosStateVersion = lib.mkOption {
        type = lib.types.str;
        default = "25.05";
      };
      homeManagerStateVersion = lib.mkOption {
        type = lib.types.str;
        default = "25.05";
      };
      language = lib.mkOption {
        type = lib.types.str;
        default = "en";
      };
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Berlin";
      };
      keyboardLayout = lib.mkOption {
        type = lib.types.str;
        default = "de";
      };
      environment.enable = lib.mkEnableOption "Enables environment configuration";
      serverAddress = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = {
    networking.hostName = config.settings.general.name;

    time.timeZone = config.settings.general.timeZone;

    system.autoUpgrade = {
      enable = true;
      flake = "path:${
        config.users.users.${config.settings.users.primary}.home
      }/nix-conf#${config.networking.hostName}";
      flags = [
        "--print-build-logs"
      ];
      dates = "10:00";
      randomizedDelaySec = "45min";
    };

    # enable flakes
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    system.stateVersion = config.settings.general.nixosStateVersion;

    i18n.defaultLocale = lib.mkIf (config.settings.general.language == "en") "en_US.UTF-8";

    i18n.extraLocaleSettings = lib.mkIf (config.settings.general.keyboardLayout == "de") {
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

    # Configure console keymap
    console.keyMap = lib.mkIf (config.settings.general.keyboardLayout == "de") "de";

    services.xserver.xkb = lib.mkIf (config.settings.general.keyboardLayout == "de") {
      layout = "de";
      variant = "";
    };

    environment.variables = lib.mkIf config.settings.general.environment.enable {
      EDITOR = "nvim";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      WLR_RENDERER_ALLOW_SOFTWARE = 1;
    };

    home-manager.users.${config.settings.users.primary} =
      let
        nixos-config = config;
      in
      { config, ... }:
      {

        programs.home-manager.enable = true;

        home.username = "${nixos-config.settings.users.primary}";
        home.homeDirectory = "/home/${nixos-config.settings.users.primary}";

        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        home.stateVersion = nixos-config.settings.general.homeManagerStateVersion;
      };
  };
}
