{ lib, config, ... }:
{
  services.syncthing.settings = lib.mkIf (config.networking.hostName == "PC") {
    devices = {
      "T480" = {
        id = "Z3EA4H3-RNVAKPJ-JIWF4HD-L4AISEX-DUZZ4SV-P3E45GU-AKA3DHG-VYQNRAK";
      };
      # "T440P" = {
      #   id = "";
      # };
    };

    folders = {
      "Dokumente" = {
        path = "/home/falk/Dokumente";
        devices = [
          "T480"
          # "T440P"
        ];
      };
    };
  };
}
