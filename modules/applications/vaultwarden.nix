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
    };
  };
  config = lib.mkIf (config.applications.configuration.vaultwarden-server.enable) {
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
