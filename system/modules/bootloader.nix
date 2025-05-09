{ lib, config, ... }:
{

  options = {
    bootloader-module = {
      enable = lib.mkEnableOption "Enables Bootlaoder module";
      os-prober.enable = lib.mkEnableOption "Enables Os-Prober";
    };
  };
  config = lib.mkIf config.bootloader-module.enable {
    boot.loader.systemd-boot.enable = false;
    boot.loader = {
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = lib.mkIf config.bootloader-module.os-prober.enable true;
        efiSupport = true;
        extraEntries = ''
          menuentry "Reboot" {
              reboot
          }
          menuentry "Poweroff" {
              halt
          }
        '';
      };
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
  };
}
