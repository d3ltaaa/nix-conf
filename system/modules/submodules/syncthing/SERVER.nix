{
  lib,
  config,
  variables,
  ...
}:
{
  services.syncthing.settings = lib.mkIf (config.networking.hostName == "SERVER") {
    devices = {
      "PC" = {
        id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
      };
      "T480" = {
        id = "Z3EA4H3-RNVAKPJ-JIWF4HD-L4AISEX-DUZZ4SV-P3E45GU-AKA3DHG-VYQNRAK";
      };
      "T440P" = {
        id = "CAWY2HI-K3QLENX-QABH4C4-QDGBZAB-GH22BRL-ZB6YBG5-PXVDZTR-4MSF7QY";
      };
    };

    folders = {
      "Dokumente" = {
        path = "/mnt/syncthing/Dokumente";
        devices = [
          "T480"
          "PC"
          "T440P"
        ];
      };
      "Bilder" = {
        path = "/mnt/syncthing/Bilder";
        devices = [
          "T480"
          "PC"
          "T440P"
        ];
      };
    };
  };
}
