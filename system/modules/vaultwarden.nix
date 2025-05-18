{ lib, config, ... }:
{
  options = {
    vaultWarden-module = {
      enable = lib.mkEnableOption "Enables vaultWarden module";
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
    (lib.mkIf (config.vaultWarden-module.enable == true && config.vaultWarden-module.type == "server") {
      networking.firewall.allowedTCPPorts = [ 8222 ];
      services.vaultwarden = {
        enable = true;
        config = {
          ROCKET_ADDRESS = "192.168.2.12";
          ROCKET_PORT = "8222";
        };
      };
    })
  ];
}
