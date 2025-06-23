{ lib, config, ... }:
{
  options = {
    applications.configuration.dnsmasq-server = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      address = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
    };
  };

  config = {
    services.dnsmasq = {
      enable = config.applications.configuration.dnsmasq-server.enable;
      settings = {
        domain-needed = true;
        bogus-priv = true;
        no-resolv = true;
        log-queries = true;
        log-facility = "/var/log/dnsmasq.log";

        server = [
          "1.1.1.1"
        ];

        listen-address = [
          "127.0.0.1"
          "::1"
          "${config.settings.networking.staticIp}"
          "fd00::11"
        ];

        address = config.applications.configuration.dnsmasq-server.address;
      };
    };
  };
}
