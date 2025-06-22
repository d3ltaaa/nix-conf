{ lib, config, ... }:
{
  options = {
    applications.configuration.nginx-server = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      virtualHosts = lib.mkOption {
        type = lib.types.attrsOf (lib.types.atttrs);
      };
    };
  };
  config = {
    # Web Reverse Proxy: Nginx
    services.nginx = {
      enable = config.applications.configuration.nginx-server.enable;
      virtualHosts = config.applications.configuration.nginx-server.virtualHosts;
    };
  };
}
