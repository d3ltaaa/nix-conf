{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    settings.users.primary = lib.mkOption {
      type = lib.types.str;
      default = "falk";
    };
  };
  config = {
    users.users.${config.settings.users.primary} = {
      isNormalUser = true;
      initialPassword = "${config.settings.users.primary}";
      description = "${config.settings.users.primary}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
      ];
      shell = pkgs.zsh;
    };

    # needed for neovim
    security.sudo.extraConfig = "Defaults        !sudoedit_checkdir";

    # set initial password

    home-manager.users.${config.settings.users.primary} =
      let
        nixos-config = config;
      in
      { config, ... }:
      {
        xdg.userDirs = {
          enable = true;
          createDirectories = true;
          documents = "/home/${nixos-config.settings.users.primary}/Dokumente";
          download = "/home/${nixos-config.settings.users.primary}/Downloads";
          pictures = "/home/${nixos-config.settings.users.primary}/Bilder";
          music = "/home/${nixos-config.settings.users.primary}/Audio";
          videos = "/home/${nixos-config.settings.users.primary}/Videos";
          templates = null;
          publicShare = null;
          desktop = null;
          extraConfig = {
            XDG_SCREENSHOT_DIR = "/home/${nixos-config.settings.users.primary}/Bilder/Screenshots";
          };
        };
      };
  };
}
