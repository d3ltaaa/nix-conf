{ lib, config, ... }:
{
  options = {
    applications.configuration.acme-server = {
      enable = lib.mkEnableOption "Enables acme configuration";
      domain = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "hil.falk@protonmail.com";
      };
      dnsProvider = lib.mkOption {
        type = lib.types.str;
        default = "ipv64";
      };
      domainNames = lib.mkOption {
        type = lib.types.listOf (lib.types.str);
      };
    };
  };
  config = lib.mkIf config.applications.configuration.acme-server.enable {
    # remember to put api key into /etc/credentials/acmeIPV64.cert

    # regenerate certs with
    # sudo rm -r /var/lib/acme
    # sudo systemctl restart acme-setup.service
    # sudo nixos-rebuild

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = config.applications.configuration.acme-server.email;
        dnsProvider = config.applications.configuration.acme-server.dnsProvider;
        dnsResolver = "1.1.1.1:53";
      };
      certs."${config.applications.configuration.acme-server.domain}" = {
        # domain = "*.${serverAddress}";
        credentialFiles = {
          IPV64_API_KEY_FILE = lib.mkIf (
            config.applications.configuration.acme-server.dnsProvider == "ipv64"
          ) "/etc/credentials/acmeIPV64.cert";
        };
        extraDomainNames = config.applications.configuration.acme-server.domainNames;
      };
    };
  };
}
