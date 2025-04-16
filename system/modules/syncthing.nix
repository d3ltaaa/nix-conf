{ lib, config, ... }:
{
  options = {
    syncthing-module.enable = lib.mkEnableOption "Enables Syncthing module";
  };
  imports = [
    ./submodules/syncthing/T480.nix
    ./submodules/syncthing/PC.nix
  ];
  config = lib.mkIf config.syncthing-module.enable {
    services.syncthing = {
      enable = true;
      dataDir = "/home/falk";
      user = "falk";
      openDefaultPorts = true;
    };
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync
  };
}
