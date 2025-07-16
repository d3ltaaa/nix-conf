{
  lib,
  config,
  ...
}:
{
  options = {
    applications.configuration.homepage-server = {
      enable = lib.mkEnableOption "Enables Homepage module";
      widgets = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };
      bookmarks = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };
      services = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };
    };
  };
  config = lib.mkIf config.applications.configuration.homepage-server.enable {
    services.homepage-dashboard = {
      enable = true;
      # allowedHosts = "${config.settings.networking.staticIp}:8082,home.${config.settings.general.serverAddress}";
      openFirewall = true;
      widgets = config.applications.configuration.homepage-server.widgets;
      bookmarks = config.applications.configuration.homepage-server.bookmarks;
      services = config.applications.configuration.homepage-server.services;
    };
  };
}
