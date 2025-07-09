{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configuration.thunar.enable = lib.mkEnableOption "Enables Thunar module";
  };
  config = lib.mkIf config.applications.configuration.thunar.enable {
    services = {
      gvfs.enable = true; # set of backends like trash management
      tumbler.enable = false; # thumbnails
    };

    programs = {
      # xfconf.enable = true; # configuration daemon for xfce applications
      # file-roller.enable = true; # archive-operations

      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          # thunar-archive-plugin
          # thunar-volman
        ];
      };
    };

    # systemd.user.services.thunar-daemon = {
    #   description = "Enable thunar-daemon";
    #   after = [ "network.target" ];
    #   wantedBy = [ "default.target" ];
    #   serviceConfig = {
    #     Type = "oneshot";
    #     RemainAfterExit = true;
    #     ExecStart = "${pkgs.xfce.thunar}/bin/thunar --daemon";
    #   };
    # };

    home-manager.users.${config.settings.users.primary} =
      { config, ... }:
      {
        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            "inode/directory" = [ "thunar.desktop" ];
            "x-scheme-handler/file" = [ "thunar.desktop" ];
            "applications/x-gnome-saved-search" = [ "thunar.desktop" ];
          };
        };
      };
  };
}
