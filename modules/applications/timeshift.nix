{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configuration.timeshift.enable = lib.mkEnableOption "Enables timeshift";
    applications.configuration.timeshift.wayland = lib.mkEnableOption "Enables Options for wayland";
  };
  config = lib.mkIf config.applications.configuration.timeshift.enable {
    environment.systemPackages = with pkgs; [
      timeshift-unwrapped
      (pkgs.writeShellScriptBin "timeshift-wayland" ''
        # Forward environment variables properly
        pkexec env DISPLAY="$DISPLAY" WAYLAND_DISPLAY="$WAYLAND_DISPLAY" XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" ${pkgs.timeshift}/bin/timeshift-gtk "$@"
      '')
    ];
    home-manager.users.${config.settings.users.primary} =
      let
        nixos-config = config;
      in
      { config, ... }:
      {
        xdg.desktopEntries.timeshift-gtk = lib.mkForce {
          name = "Timeshift";
          type = "Application";
          genericName = "System Restore Utility";
          terminal = false;
          icon = "timeshift";
          comment = "System Restore Utility";
          categories = [ "System" ];
          exec = lib.mkIf nixos-config.applications.configuration.timeshift.wayland "timeshift-wayland";
        };
      };

  };
}
