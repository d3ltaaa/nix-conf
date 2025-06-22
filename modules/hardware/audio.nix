{ lib, config, ... }:
{
  options = {
    hardware.audio.enable = lib.mkEnableOption "Enables pulseaudio";
  };
  config = lib.mkIf config.hardware.audio.enable {
    services = {
      pulseaudio.enable = true;
      pulseaudio.support32Bit = true;
      pipewire.enable = false;
    };
  };
}
