{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configuration.spotify.enable = lib.mkEnableOption "Enables Spotify module";
  };

  config = lib.mkIf config.applications.configuration.spotify.enable {
    environment.systemPackages = with pkgs; [ spotify ];
    services.playerctld.enable = true;
    networking.networkmanager.settings.connectivity.uri =
      "http://nmcheck.gnome.org/check_network_status.txt"; # fix for spotify (always showed connectivity limited)
  };
}
