{ lib, config, ... }:
{
  options = {
    flatpak-module.enable = lib.mkEnableOption "Enables Flatpaks";
    # Add a new remote. Keep the default one (flathub)
  };

  config = lib.mkIf config.flatpak-module.enable {
    xdg.portal.enable = true;

    services.flatpak = {
      enable = true;

      remotes = lib.mkOptionDefault [
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];

      update.auto.enable = false;
      uninstallUnmanaged = false;

      # Add here the flatpaks you want to install
      packages = [
        "com.obsproject.Studio"
        "net.mkiol.SpeechNote"
      ];
    };
  };
}
