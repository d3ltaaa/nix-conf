{
  lib,
  config,
  variables,
  ...
}:
let
  serverAddress = lib.strings.trim (builtins.readFile "/home/${variables.user}/.server_address");
in
{

  options = {
    connections-module = {
      enable = lib.mkEnableOption "Enables Connections module";
      type = lib.mkOption {
        type = lib.types.enum [
          "server"
          "client"
        ];
        default = "client";
      };
    };
  };
  config = lib.mkMerge [
    (lib.mkIf (config.connections-module.enable == true && config.connections-module.type == "client") {

      # Enable networking
      networking.networkmanager.enable = true;

      # Enable blutooth
      hardware.bluetooth.enable = true;
      networking.networkmanager.ensureProfiles.profiles = {
        "home-ethernet" = {
          connection = {
            id = "Wired connection 1";
            type = "ethernet";
          };
          ipv4 = {
            method = "auto";
            dns = "192.168.2.11;192.168.2.1";
            dns-priority = -10;
          };
          ipv6.method = "auto";
        };
        "home-wifi-2.4" = {
          connection = {
            id = "Wlan-12-2.4";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
            dns = "192.168.2.11;192.168.2.1";

            dns-priority = -10;
          };
          ipv6.method = "auto";
        };
        "home-wifi-12-5" = {
          connection = {
            id = "Wlan-12-5";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
            dns = "192.168.2.11;192.168.2.1";
            dns-priority = -10;
          };
          ipv6.method = "auto";
        };
      };

    })
    (lib.mkIf (config.connections-module.enable == true && config.connections-module.type == "server") {
      networking = {
        useDHCP = false;
        interfaces.ens18.ipv4.addresses = [
          {
            address = "192.168.2.11";
            prefixLength = 24;
          }
        ];
        interfaces.ens18.ipv6.addresses = [
          {
            address = "fd12:3456:789a::11";
            prefixLength = 64;
          }
        ];
        defaultGateway = "192.168.2.1";
        nameservers = [
          "1.1.1.1"
        ]; # or your router's DNS

        nat = {
          enable = true;
          externalInterface = "ens18";
          internalInterfaces = [ "wg0" ];
        };
      };

      networking.firewall.allowedTCPPorts = [
        53
        80
        443
      ];
      networking.firewall.allowedUDPPorts = [ 53 ];

      # DNS Server: dnsmasq
      services.dnsmasq = {
        enable = true;
        settings = {
          domain-needed = true;
          bogus-priv = true;
          no-resolv = true;
          log-queries = true;
          log-facility = "/var/log/dnsmasq.log";

          # Upstream DNS for external names
          server = [
            "1.1.1.1"
          ];
          listen-address = [
            "127.0.0.1"
            "::1"
            "192.168.2.11"
            "fd00::11"
          ];

          address = [
            "/${serverAddress}/192.168.2.11"
          ];
        };
      };

      # Web Reverse Proxy: Nginx
      services.nginx = {
        enable = true;
        virtualHosts = {
          "proxmox.${serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "https://192.168.2.10:8006";
              proxyWebsockets = true;
              extraConfig = ''
                client_max_body_size 8G;
                proxy_buffering off;
                proxy_request_buffering off;
                proxy_connect_timeout 3600;
                proxy_send_timeout 3600;
                proxy_read_timeout 3600;
              '';
            };
          };
          "dp.${serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.31:80"; # allow dp.${serverAddress} in moonraker manually
              proxyWebsockets = true;
            };
          };
          "vault.${serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:8222";
              proxyWebsockets = true;
            };
          };
        };
      };

      security.acme = {
        acceptTerms = true;
        defaults.email = "hil.falk@protonmail.com";
        certs."${serverAddress}" = {
          dnsProvider = "ipv64";
          extraDomainNames = [
            "dp.${serverAddress}"
            "proxmox.${serverAddress}"
            "vault.${serverAddress}"
          ];
          credentialFiles = {
            IPV64_API_KEY_FILE = "/home/${variables.user}/credentials.sh";
          };
        };
      };

      # # Web Reverse Proxy: Caddy
      # services.caddy = {
      #   enable = true;
      #
      #   virtualHosts = {
      #     "proxmox.internal" = {
      #       extraConfig = ''
      #         reverse_proxy 192.168.2.10:8006 {
      #           transport http {
      #             tls_insecure_skip_verify
      #           }
      #         }
      #       '';
      #     };
      #   };
      # };
    })
  ];
}
