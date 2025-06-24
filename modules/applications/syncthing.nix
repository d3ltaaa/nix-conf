{ lib, config, ... }:
{
  options = {
    applications.configuration.syncthing = {
      enable = lib.mkEnableOption "Enables Syncthing module";
      devices = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
      };
      folders = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
      };
      gui = lib.mkEnableOption "Enables gui access from outside";
    };
  };
  config = lib.mkIf config.applications.configuration.syncthing.enable {
    services.syncthing = {
      enable = true;
      dataDir = "/home/${config.settings.users.primary}";
      user = config.settings.users.primary;
      openDefaultPorts = lib.mkIf config.applications.configuration.syncthing.gui true;
      guiAddress = lib.mkIf config.applications.configuration.syncthing.gui "0.0.0.0:8384";
      settings = {
        devices = config.applications.configuration.syncthing.devices;
        folders = config.applications.configuration.syncthing.folders;
      };
    };
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync
  };
}
