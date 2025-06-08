{
  lib,
  config,
  ...
}:
{
  options = {
    tablet-module.enable = lib.mkEnableOption "Enables Tablet module";
  };
  config = lib.mkIf config.tablet-module.enable {
    hardware.opentabletdriver.enable = true;
  };
}
