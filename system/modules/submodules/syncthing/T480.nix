{
  lib,
  config,
  variables,
  ...
}:
{
  services.syncthing.settings = lib.mkIf (config.networking.hostName == "T480") {
    devices = {
      "PC" = {
        id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
      };
      "T440P" = {
        id = "CAWY2HI-K3QLENX-QABH4C4-QDGBZAB-GH22BRL-ZB6YBG5-PXVDZTR-4MSF7QY";
      };
    };

    folders = {
      "Dokumente" = {
        path = "${variables.userHomeDir}/Dokumente";
        devices = [
          "PC"
          "T440P"
        ];
      };
      "Bilder" = {
        path = "${variables.userHomeDir}/Bilder";
        devices = [
          "PC"
          "T440P"
        ];
      };
    };
  };
}
