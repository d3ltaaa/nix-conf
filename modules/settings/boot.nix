{ lib, config, ... }:
{
  options = {
    settings.boot = {
      primaryBoot = lib.mkEnableOption "";
      osProber = lib.mkEnableOption "Enable Os-Prober";
      defaultEntry = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };
      extraEntries = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };
  config = {
    boot.loader.systemd-boot.enable = false;
    boot.loader = {
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = config.settings.boot.primaryBoot;
      };
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = config.settings.boot.osProber;
        efiSupport = true;
        configurationName = "NixOS (${config.settings.general.name})";
        default = lib.mkIf (config.settings.boot.defaultEntry != null) config.settings.boot.defaultEntry;
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
          in
          (if config.settings.boot.extraEntries != null then config.settings.boot.extraEntries else "")
          + defaultEntries;
      };
    };
  };
}
