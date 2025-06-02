{
  lib,
  config,
  variables,
  ...
}:
{

  options = {
    homeassistant-module = {
      enable = lib.mkEnableOption "Enables Homeassistant module";
    };
  };
  config = lib.mkIf config.homeassistant-module.enable {
    networking.firewall.allowedUDPPorts = [ 8123 ];
    networking.firewall.allowedTCPPorts = [ 8123 ];
    virtualisation = {
      podman.enable = true;
      oci-containers = {
        containers = {
          homeassistant = {
            image = "homeassistant/home-assistant:stable";
            autoStart = true;
            extraOptions = [
              "--network=host"
              "--pull=newer"
            ];
            volumes = [
              "/var/lib/homeassistant:/config"
            ];
            # ports = [
            #   "0.0.0.0:8123:8123"
            #   "0.0.0.0:8124:80"
            # ];
            environment = {
              TZ = "Europe/Berlin";
              PUID = toString config.users.users.${variables.user}.uid;
              PGID = toString config.users.groups.users.gid;
            };
          };
        };
      };
    };
  };
}
