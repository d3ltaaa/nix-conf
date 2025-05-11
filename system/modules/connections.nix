{ lib, config, ... }:
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
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Enable blutooth
      hardware.bluetooth.enable = true;

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # Enable the OpenSSH daemon.

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;
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
          "192.168.2.1"
        ]; # or your router's DNS
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
            "/proxmox.internal/192.168.2.11"
            # "/media.internal/192.168.2.11"
            # "/home.internal/192.168.2.11"
            # "/files.internal/192.168.2.11"
          ];
        };
      };

      # Web Reverse Proxy: Caddy
      services.caddy = {
        enable = true;

        virtualHosts = {
          "proxmox.internal" = {
            extraConfig = ''
              reverse_proxy 192.168.2.10:8006 {
                transport http {
                  tls_insecure_skip_verify
                }
              }
            '';
          };
          # "media.internal" = {
          #   extraConfig = ''
          #     reverse_proxy 192.168.2.12:8081
          #   '';
          # };
          # "home.internal" = {
          #   extraConfig = ''
          #     reverse_proxy 192.168.2.12:8123
          #   '';
          # };
          # "files.internal" = {
          #   extraConfig = ''
          #     reverse_proxy 192.168.2.12:8000
          #   '';
          # };
        };
      };
    })
  ];
}
