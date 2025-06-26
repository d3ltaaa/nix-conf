{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.audio.enable = lib.mkEnableOption "Enables pulseaudio";
  };
  config = lib.mkIf config.hardware.audio.enable {
    services = {
      # pulseaudio.enable = true;
      # pulseaudio.support32Bit = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

    };
    environment.systemPackages = with pkgs; [
      pulseaudio # for pactl (needed for scripts)
    ];
  };
}
