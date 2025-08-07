{ pkgs, ... }:
{
  networking.networkmanager.wifi.macAddress = "random";
  networking.networkmanager.wifi.scanRandMacAddress = true; # (default)

  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [ opensnitch-ui ];
  # settings > ui > autostart ui
  # settings > Pop-ups > Duration = Forever

  services.opensnitch = {
    enable = true;
  };
}
