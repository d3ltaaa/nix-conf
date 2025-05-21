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
    virtualisation = {
      podman.enable = true;
      oci-containers = {
        containers = {
          homeassistant = {
            image = "homeassistant/home-assistant:stable";
            autoStart = true;
            extraOptions = [
              "--pull=newer"
            ];
            volumes = [
              "/etc/homeassistant/config"
            ];
            ports = [
              "127.0.0.1:8123:8123"
              "127.0.0.1:8124:80"
            ];
            environment = {
              PUID = toString config.users.users.${variables.user}.uid;
              PGID = toString config.users.groups.${variables.group}.gid;
            };
          };
        };
      };
    };
  };
}
