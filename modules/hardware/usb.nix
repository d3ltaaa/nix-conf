{ lib, config, ... }:
{
  options = {
    hardware.usb.enable = lib.mkEnableOption "Enables Usdisks2";
  };
  config = lib.mkIf config.hardware.usb.enable {
    services.udisks2.enable = true;
  };
}
