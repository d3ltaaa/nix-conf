{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configuration.vaultwarden-server = {
      enable = lib.mkEnableOption "Enables Vaultwarden module";
      role = lib.mkOption {
        type = lib.types.enum [
          "server"
          "client"
        ];
        default = "client";
      };
    };
  };
  config =
    lib.mkIf
      (
        config.applications.configuration.vaultwarden-server.enable
        && config.applications.configuration.vaultwarden-server.role == "server"
      )
      {
        networking.firewall.allowedTCPPorts = [ 8222 ];
        services.vaultwarden = {
          enable = true;
          config = {
            ROCKET_ADDRESS = "192.168.2.12";
            ROCKET_PORT = "8222";
          };
        };
      };
}
