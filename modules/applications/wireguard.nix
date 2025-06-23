{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    applications.configuration.wireguard-client = {
      enable = lib.mkEnableOption "Enables Wireguard-client module";
      address = lib.mkOption {
        type = lib.types.listOf (lib.types.str);
      };
      dns = lib.mkOption {
        type = lib.types.listOf (lib.types.str);
      };
      serverPublicKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };

    applications.configuration.wireguard-server = {
      enable = lib.mkEnableOption "Enables Wireguard-server module";
      serverPeers = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              publicKey = lib.mkOption {
                type = lib.types.str;
                description = "The public key of the peer.";
              };

              allowedIPs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                description = "List of allowed IPs for the peer.";
              };
            };
          }
        );

        default = [ ];
        description = "List of WireGuard peers.";
      };
    };
  };

  config =
    lib.mkIf
      (
        config.applications.configuration.wireguard-client.enable
        || config.applications.configuration.wireguard-server.enable
      )
      (
        lib.mkMerge [

          {
            networking = {
              wireguard.enable = true;
            };
          }

          (lib.mkIf config.applications.configuration.wireguard-client.enable {
            networking = {
              wg-quick.interfaces.wg0 = {
                address = config.applications.configuration.wireguard-client.address;
                dns = config.applications.configuration.wireguard-client.dns;
                listenPort = null; # Don't listen for incoming connections (client-only)
                privateKeyFile = "/etc/credentials/wireguard-keys/private";
                peers = [
                  {
                    publicKey = config.applications.configuration.wireguard-client.serverPublicKey;
                    endpoint = "${config.settings.general.serverAddress}:51920";
                    allowedIPs = [
                      # only route VPN subnet traffic
                      "10.100.0.0/24"
                      "192.168.2.0/24"
                    ];
                    persistentKeepalive = 25;
                  }
                ];
              };
            };
          })
          (lib.mkIf config.applications.configuration.wireguard-server.enable {
            environment.systemPackages = with pkgs; [
              wireguard-tools
            ];
            # imperative

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
              firewall.allowedUDPPorts = [
                51820 # imperative
                51920 # declarative
              ];
            };
            networking.wireguard.interfaces.wg1 = {
              # Determines the IP address and subnet of the server's end of the tunnel interface.
              ips = [ "10.100.0.1/24" ];

              # The port that WireGuard listens to. Must be accessible by the client.
              listenPort = 51920; # must be different from imparative llistenPort

              # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
              # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
              postSetup = ''
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${config.settings.networking.lanInterface} -j MASQUERADE
              '';

              # This undoes the above command
              postShutdown = ''
                ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${config.settings.networking.lanInterface} -j MASQUERADE
              '';

              privateKeyFile = "/home/${config.settings.users.primary}/.wireguard-keys/private";

              peers = config.applications.configuration.wireguard-server.serverPeers;
            };

            # wireguard-ui
            networking.firewall.allowedTCPPorts = [ 5000 ]; # port for wireguard-webui
            systemd.services.wireguard-ui = {
              enable = true;
              description = "WireGuard-UI Web Interface";
              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];

              serviceConfig = {
                ExecStart = "${pkgs.wireguard-ui}/bin/wireguard-ui"; # path to wireguard-ui binary
                # Run as root (default), so no User/Group needed
                WorkingDirectory = "/etc/wireguard"; # or wherever configs live
                StandardOutput = "journal";
                StandardError = "journal";
              };
            };

            systemd.services.wgui = {
              enable = true;
              description = "Restart WireGuard";
              after = [ "network.target" ];
              serviceConfig = {
                Type = "oneshot";
                ExecStart = "${pkgs.systemd}/bin/systemctl restart wg-quick@wg0.service";
              };
              wantedBy = [ "wgui.path" ]; # makes path unit trigger this service
            };

            systemd.paths.wgui = {
              enable = true;
              description = "Watch /etc/wireguard/wg0.conf for changes";
              pathConfig = {
                PathModified = "/etc/wireguard/wg0.conf";
              };
              wantedBy = [ "multi-user.target" ];
            };
          })
        ]
      );
}
