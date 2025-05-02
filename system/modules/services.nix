{ lib, config, ... }:
{
  imports = [
    ./submodules/services/auto-cpufreq.nix
    ./submodules/services/autoLogin.nix
    ./submodules/services/tlp.nix
    ./submodules/services/printing.nix
  ];

  options = {
    services-module = {
      enable = lib.mkEnableOption "Enables Services module";
      services = {
        powerManagement = lib.mkEnableOption "Enables Power powerManagement services";
        audio = lib.mkEnableOption "Enables pulseaudio";
        printing = lib.mkEnableOption "Enables printing";
        usb = lib.mkEnableOption "Enables usb (udisks2)";
        login = lib.mkEnableOption "Enables autologinOnce";
        flatpaks = lib.mkEnableOption "Enables flatpaks";
      };
    };
  };
  config = lib.mkIf config.services-module.enable {
    services = lib.mkMerge [
      # powerManagement
      (lib.mkIf config.services-module.services.powerManagement {
        upower.enable = true;
        auto-cpufreq.enable = true;
        tlp.enable = true;
      })

      (lib.mkIf config.services-module.services.audio {
        pulseaudio.enable = true;
        pulseaudio.support32Bit = true;
        pipewire.enable = false;
      })

      (lib.mkIf config.services-module.services.usb {
        udisks2.enable = true;
      })

      (lib.mkIf config.services-module.services.login {
        getty.autologinOnce = true;
        hypridle.enable = true;
      })

      (lib.mkIf config.services-module.services.printing {
        printing.enable = true;
        samba.enable = true;
        avahi.enable = true;
      })
    ];
  };
}
