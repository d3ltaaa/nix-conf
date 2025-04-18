{
  lib,
  config,
  variables,
  ...
}:
{
  services.syncthing.settings = lib.mkIf (config.networking.hostName == "PC") {
    devices = {
      "T480" = {
        id = "Z3EA4H3-RNVAKPJ-JIWF4HD-L4AISEX-DUZZ4SV-P3E45GU-AKA3DHG-VYQNRAK";
      };
      "T440P" = {
        id = "CAWY2HI-K3QLENX-QABH4C4-QDGBZAB-GH22BRL-ZB6YBG5-PXVDZTR-4MSF7QY";
      };
    };

    folders = {
      "Dokumente" = {
        path = "${variables.userHomeDir}/Dokumente";
        devices = [
          "T480"
          "T440P"
        ];
      };
      "Bilder" = {
        path = "${variables.userHomeDir}/Bilder";
        devices = [
          "T480"
          "T440P"
        ];
      };
    };
  };
}
