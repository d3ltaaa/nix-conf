{ pkgs, ... }:
{
  networking.networkmanager.wifi.macAddress = "random";
  networking.networkmanager.wifi.scanRandMacAddress = true; # (default)

  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [ opensnitch-ui ];
  services.opensnitch = {
    enable = true;
  };
}
