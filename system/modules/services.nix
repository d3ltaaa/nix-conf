{ lib, config, ... }:
{
  imports = [
    ./submodules/services/auto-cpufreq.nix
    ./submodules/services/autoLogin.nix
    ./submodules/services/tlp.nix
    ./submodules/services/printing.nix
  ];

  options = {
    services-module.enable = lib.mkEnableOption "Enables Services module";
  };
  config = lib.mkIf config.services-module.enable {
    services = {
      upower.enable = true;
      udisks2.enable = true;
      hypridle.enable = true;
      pulseaudio.enable = true;
      pulseaudio.support32Bit = true;
      pipewire.enable = false;
    };
  };
}
