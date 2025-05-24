{
  config,
  pkgs,
  lib,
  ...
}:
{
  config =
    lib.mkIf (config.networking.hostName == "PC" || config.networking.hostName == "PC-SERVER")
      {
        networking = {
          useDHCP = false;
          defaultGateway = "192.168.2.1";
          nameservers = [
            "192.168.2.11"
            "192.168.2.1"
          ]; # or your router's DNS

          interfaces.eno1 = {
            wakeOnLan.enable = true;
            ipv4.addresses = [
              {
                address = "192.168.2.30";
                prefixLength = 24;
              }
            ];
          };
        };

        systemd.services.wakeonlan = {
          description = "Re-enable Wake-on-LAN every boot";
          after = [ "network.target" ];
          wantedBy = [ "default.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.ethtool}/sbin/ethtool -s eno1 wol g";
          };
        };
      };
}
