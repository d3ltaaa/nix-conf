{ lib, config, ... }:
{
  options = {
    userdirs-module.enable = lib.mkEnableOption "Enables Userdirs module";
  };
  config = lib.mkIf config.userdirs-module.enable {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${config.home.homeDirectory}/Dokumente";
      download = "${config.home.homeDirectory}/Downloads";
      pictures = "${config.home.homeDirectory}/Bilder";
      music = "${config.home.homeDirectory}/Audio";
      videos = "${config.home.homeDirectory}/Videos";
      templates = null;
      publicShare = null;
      desktop = null;
      extraConfig = {
        XDG_SYNC_DIR = "${config.home.homeDirectory}/Sync";
      };
    };
  };
}
