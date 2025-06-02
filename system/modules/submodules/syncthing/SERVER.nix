{
  lib,
  config,
  variables,
  ...
}:
{
  config = lib.mkIf (config.networking.hostName == "SERVER") {
    networking.firewall.allowedTCPPorts = [ 8384 ];
    services.syncthing = {
      openDefaultPorts = true;
      guiAddress = "0.0.0.0:8384";
      settings = {
        devices = {
          "PC" = {
            id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
          };
          "T480" = {
            id = "OHXDERI-SBNTM5Q-ZBM7UMC-BZUOLDB-U32FQZW-VNXGSH7-VKQTNJO-TM3VWAH";
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
    };
  };
}
