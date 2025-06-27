{ lib, config, ... }:
{
  options = {
    hardware.blueTooth.enable = lib.mkEnableOption "Enables Bluetooth";
  };
  config = lib.mkIf config.hardware.blueTooth.enable {
    hardware.bluetooth.enable = true;
  };
}
