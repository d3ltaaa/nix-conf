{ lib, config, ... }:
{
  options = {
    applications.configuration.n8n-server = {
      enable = lib.mkEnableOption "Enables n8n Module";
    };
  };
  config = lib.mkIf config.applications.configuration.n8n-server.enable {
    networking.firewall.allowedTCPPorts = [ 5678 ];
    services.n8n.enable = true;
  };
}
