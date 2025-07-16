{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.tablet.enable = lib.mkEnableOption "Enables Opentabletdriver";
  };
  config = lib.mkIf config.hardware.tablet.enable {
    hardware.opentabletdriver.enable = true;
    hardware.opentabletdriver.package = pkgs.opentabletdriver;
  };
}
