{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configuration.firefox.enable = lib.mkEnableOption "Enables Firefox module and screensharing capabilities";
  };

  config = lib.mkIf config.applications.configuration.firefox.enable {
    programs.firefox = {
      enable = true;
      package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { });
    };

    hardware.audio.enable = lib.mkDefault true; # needs pipewire

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };
  };
}
