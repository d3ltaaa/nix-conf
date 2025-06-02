{
  lib,
  config,
  variables,
  ...
}:
{
  options = {
    syncthing-module.enable = lib.mkEnableOption "Enables Syncthing module";
  };
  imports = [
    ./submodules/syncthing/T480.nix
    ./submodules/syncthing/PC.nix
    ./submodules/syncthing/T440P.nix
    ./submodules/syncthing/SERVER.nix
  ];
  config = lib.mkIf config.syncthing-module.enable {
    services.syncthing = {
      enable = true;
      dataDir = "${variables.userHomeDir}";
      user = "${variables.user}";
      openDefaultPorts = true;
    };
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync
  };
}
