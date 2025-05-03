{
  lib,
  config,
  pkgs,
  variables,
  ...
}:

let
  serverAddress = lib.strings.trim (builtins.readFile "/home/${variables.user}/.server_address");
in
{
  networking = lib.mkIf (config.networking.hostName == "T480") {
    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          ips = [ "10.100.0.2/32" ];

          # Don't listen for incoming connections (client-only)
          listenPort = null;

          privateKeyFile = "/home/${variables.user}/.wireguard-keys/private";

          peers = [
            {
              # server
              publicKey = "hAvazVD4FMIbtZPLa5rtUXrZ3iXYIiW5Ivemyv1UmWA=";
              endpoint = "${serverAddress}:51920";
              # allowedIPs = [ "0.0.0.0/0" ]; # Route all traffic through VPN
              allowedIPs = [
                "10.100.0.0/24"
                "192.168.2.0/24"
              ]; # only routes VPN subnet traffic
              persistentKeepalive = 25; # Helps with NAT traversal
            }
          ];
        };
      };
    };
  };
}
