{ lib, config, ... }:
{
  options = {
    dconf-module.enable = lib.mkEnableOption "Enables Dconf module";
  };
  config = lib.mkIf config.dconf-module.enable {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
