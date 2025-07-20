{ lib, config, ... }:
{
  options = {
    applications.configuration.radicale-server.enable = lib.mkEnableOption "Enables radicale server";
  };
  config = lib.mkIf config.applications.configuration.radicale-server.enable {
    services.radicale = {
      enable = true;
      settings = {
        server = {
          # Configure host and port if needed
          hosts = "0.0.0.0:5232";
        };
        auth = {
          type = "none";
        };
        # Add any other configuration options you need
      };
    };

    # Optional: Open the firewall port
    networking.firewall.allowedTCPPorts = [ 5232 ];
  };
}
