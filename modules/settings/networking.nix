{ lib, config, ... }:
{
  options = {
    settings.networking = {
      role = lib.mkOption {
        type = lib.types.enum [
          "server"
          "client"
        ];
        default = "client";
      };
      lanInterface = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      wifiInterface = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      staticIp = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      defaultGateway = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      nameservers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "1.1.1.1" ];
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.networking.role == "client") {
      # Enable networking
      networking.networkmanager.enable = true;

    })
    (lib.mkIf (config.settings.networking.role == "server") {
      # Enable networking
      networking.networkmanager.enable = true;
      networking.networkmanager.dns = lib.mkIf (
        config.settings.networking.nameservers != [ "1.1.1.1" ]
      ) "none";

      networking = {
        useDHCP = false;
        interfaces.${config.settings.networking.lanInterface}.ipv4.addresses =
          lib.mkIf (config.settings.networking.staticIp != null)
            [
              {
                address = config.settings.networking.staticIp;
                prefixLength = 24;
              }
            ];
        defaultGateway = lib.mkIf (
          config.settings.networking.defaultGateway != null
        ) config.settings.networking.defaultGateway;
        nameservers = config.settings.networking.nameservers;

        # bridged network
        nat = {
          enable = true;
          externalInterface = config.settings.networking.lanInterface;
          internalInterfaces = [ "wg0" ];
        };
      };

      networking.firewall.allowedTCPPorts = [
        53
        80
        443
      ];
      networking.firewall.allowedUDPPorts = [ 53 ];
    })
  ];
}
