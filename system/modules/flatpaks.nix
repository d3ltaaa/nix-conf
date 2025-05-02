{ lib, config, ... }:
{
  config = {
    flatpak-module.enable = lib.mkEnableOption "Enables Flatpaks";
  };

  services.flatpaks = lib.mkIf config.flatpak-module.enable {
    enable = true;

    # Add a new remote. Keep the default one (flathub)
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

}
