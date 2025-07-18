{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configuration.ntfy-server = {
      enable = lib.mkEnableOption "Enables litellm module";
      base-url = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
  config = lib.mkIf config.applications.configuration.ntfy-server.enable {
    networking.firewall.allowedTCPPorts = [ 8070 ];
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = config.applications.configuration.ntfy-server.base-url;
        # Listen on all interfaces on port 8080
        # We'll proxy this through nginx for HTTPS
        listen-http = "0.0.0.0:8070";

        # Local network access doesn't require authentication by default
        # You can modify this for more security if needed
        auth-default-access = "read-write";

        # Behind nginx proxy
        behind-proxy = true;
      };
    };
  };
}
