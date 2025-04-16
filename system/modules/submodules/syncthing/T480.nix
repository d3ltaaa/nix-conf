{ lib, config, ... }:
{
  services.syncthing.settings = lib.mkIf (config.networking.hostName == "T480") {
    devices = {
      "PC" = {
        id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
      };
      # "T440P" = {
      #   id = "";
      # };
    };

    folders = {
      "Dokumente" = {
        path = "/home/falk/Dokumente";
        devices = [
          "PC"
          # "T440P"
        ];
      };
    };
  };
}
