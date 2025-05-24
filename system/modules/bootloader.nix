{ lib, config, ... }:
{

  options = {
    bootloader-module = {
      enable = lib.mkEnableOption "Enables Bootloader module";
      os-prober.enable = lib.mkEnableOption "Enables Os-Prober";
      secondaryOs = lib.mkEnableOption "Sets canTouchEfiVariables to false";
    };
  };
  config = lib.mkIf config.bootloader-module.enable {
    boot.loader.systemd-boot.enable = false;
    boot.loader = {
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = lib.mkIf (!config.bootloader-module.secondaryOs) true;
      };
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = lib.mkIf config.bootloader-module.os-prober.enable true;
        efiSupport = true;
        configurationName = "NixOS (${config.networking.hostName})";
        default = lib.mkIf (config.networking.hostName == "PC") "1";
        extraEntries =
          let
            defaultEntries = ''
              menuentry "Reboot" {
                  reboot
              }
              menuentry "Poweroff" {
                  halt
              }
              menuentry "Enter UEFI Firmware Settings" {
                  fwsetup
              }
            '';
            additionalEntries = ''
              menuentry "NixOs (PC-SERVER)" {
                  insmod part_gpt
                  insmod fat
                  search --no-floppy --label SERVER_BOOT --set=root
                  chainloader /EFI/NixOS-boot/grubx64.efi
              }
              menuentry "Windows 10 " {
                  insmod part_gpt
                  insmod fat
                  search --no-floppy --label W10_BOOT --set=root
                  chainloader /EFI/Microsoft/Boot/bootmgfw.efi
              }
            '';
          in
          (if config.networking.hostName == "PC" then additionalEntries else "") + defaultEntries;
      };
    };
  };
}
