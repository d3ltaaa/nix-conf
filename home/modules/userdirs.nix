{
  lib,
  config,
  userHomeDir,
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
      documents = "${userHomeDir}/Dokumente";
      download = "${userHomeDir}/Downloads";
      pictures = "${userHomeDir}/Bilder";
      music = "${userHomeDir}/Audio";
      videos = "${userHomeDir}/Videos";
      templates = null;
      publicShare = null;
      desktop = null;
      extraConfig = {
        XDG_SYNC_DIR = "${userHomeDir}/Sync";
      };
    };
  };
}
