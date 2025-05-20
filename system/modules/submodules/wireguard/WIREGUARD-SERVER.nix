{
  lib,
  config,
  variables,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.networking.hostName == "WIREGUARD-SERVER") {

    services.dnsmasq = {
      enable = true;
      settings = {
        address = [ "/proxmox.home.net/192.168.2.50" ];
        listen-address = "127.0.0.1,10.100.0.1"; # Listen on WireGuard interface too
      };
    };

    # imparative

    # install packages for imparative control
    environment.systemPackages = with pkgs; [
      wireguard-tools
      wireguard-ui
    ];

    systemd.services."wg-quick@wg0" = {
      enable = true;
      description = "Imperative WireGuard VPN (wg0)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.wireguard-tools}/bin/wg-quick up wg0";
        ExecStop = "${pkgs.wireguard-tools}/bin/wg-quick down wg0";
      };
    };

    networking = {
      firewall.allowedTCPPorts = [ 5000 ]; # port for wireguard-webui
      firewall.allowedUDPPorts = [ 51920 ]; # port for imparative wireguard

      # declarative
      wireguard = {
        interfaces = {
          # "wg0" is the network interface name. You can name the interface arbitrarily.
          wg0 = {
            # Determines the IP address and subnet of the server's end of the tunnel interface.
            ips = [ "10.100.0.1/24" ];

            # The port that WireGuard listens to. Must be accessible by the client.
            listenPort = 51930; # must be different from imparative llistenPort

            # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
            # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
            postSetup = ''
              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ens18 -j MASQUERADE
            '';

            # This undoes the above command
            postShutdown = ''
              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ens18 -j MASQUERADE
            '';

            # Path to the private key file.
            #
            # Note: The private key can also be included inline via the privateKey option,
            # but this makes the private key world-readable; thus, using privateKeyFile is
            # recommended.
            privateKeyFile = "/home/${variables.user}/.wireguard-keys/private";

            peers = [
              {
                # T480
                publicKey = "fSaTvwFYNcAx/dKxS9HCEB/017HITk/dpZCwJ1uZDDs=";
                allowedIPs = [ "10.100.0.2/32" ];
              }
              {
                # PHONE
                publicKey = "Am+PSLEvczLPxaoI/x2QEiQCe1N5/LwSzVqPD/CUDF4=";
                allowedIPs = [ "10.100.0.3/32" ];
              }
              {
                # TABS9
                publicKey = "Ggovi9VYVEHK70enoT/8/GweGBTX8xgiktRTMSGboww=";
                allowedIPs = [ "10.100.0.4/32" ];
              }
            ];
          };
        };
      };
    };
  };
}
