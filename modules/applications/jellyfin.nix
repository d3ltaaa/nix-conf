{ lib, config, ... }:
{
  options = {
    applications.configuration.jellyfin-server.enable = lib.mkEnableOption "Enables Jellyfin";
  };
  config = lib.mkIf config.applications.configuration.jellyfin-server.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
  };
}
