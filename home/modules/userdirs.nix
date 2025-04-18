{
  lib,
  config,
  variables,
  ...
}:
{
  options = {
    userdirs-module.enable = lib.mkEnableOption "Enables Userdirs module";
  };
  config = lib.mkIf config.userdirs-module.enable {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${variables.userHomeDir}/Dokumente";
      download = "${variables.userHomeDir}/Downloads";
      pictures = "${variables.userHomeDir}/Bilder";
      music = "${variables.userHomeDir}/Audio";
      videos = "${variables.userHomeDir}/Videos";
      templates = null;
      publicShare = null;
      desktop = null;
      extraConfig = {
        XDG_SYNC_DIR = "${variables.userHomeDir}/Sync";
        XDG_SCREENSHOT_DIR = "${variables.userHomeDir}/Bilder/Screenshots";
      };
    };
  };
}
