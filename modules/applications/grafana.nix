{ lib, config, ... }:
{
  options = {
    applications.configuration.grafana-server.enable = lib.mkEnableOption "Enables Grafana";
  };
  config = lib.mkIf config.applications.configuration.grafana-server.enable {
    networking.firewall.allowedTCPPorts = [ config.services.grafana.settings.server.http_port ];
    networking.firewall.allowedUDPPorts = [ config.services.grafana.settings.server.http_port ];
    services.grafana = {
      enable = true;
      settings.server = {
        http_port = 2342;
        http_addr = "0.0.0.0";
      };
    };
  };
}
