{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    hardware.tablet.enable = lib.mkEnableOption "Enables Opentabletdriver";
  };
  config = lib.mkIf config.hardware.tablet.enable {
    hardware.opentabletdriver.enable = true;
    hardware.opentabletdriver.package = nixpkgs-stable.opentabletdriver;
  };
}
