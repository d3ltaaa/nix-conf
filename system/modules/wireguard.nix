{
  lib,
  config,
  pkgs,
  variables,
  ...
}:
{
  options = {
    wireguard-module.enable = lib.mkEnableOption "Enables wireguard module";
  };
  imports = [
    ./submodules/wireguard/WIREGUARD-SERVER.nix
    ./submodules/wireguard/T480.nix
  ];

  config = lib.mkIf config.wireguard-module.enable {
    networking = {
      firewall.allowedUDPPorts = [ 51920 ];
      wireguard.enable = false;
    };
  };
}
