{ lib, config, ... }:
{
  options = {
    tablet-module.enable = lib.mkEnableOption "Enables Homepage module";
  };
  config = lib.mkIf config.tablet-module.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
