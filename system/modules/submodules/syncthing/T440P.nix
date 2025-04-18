{
  lib,
  config,
  variables,
  ...
}:
{
  services.syncthing.settings = lib.mkIf (config.networking.hostName == "T440P") {
    devices = {
      "PC" = {
        id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
      };
      "T480" = {
        id = "Z3EA4H3-RNVAKPJ-JIWF4HD-L4AISEX-DUZZ4SV-P3E45GU-AKA3DHG-VYQNRAK";
      };
    };

    folders = {
      "Dokumente" = {
        path = "${variables.userHomeDir}/Dokumente";
        devices = [
          "T480"
          "PC"
        ];
      };
      "Bilder" = {
        path = "${variables.userHomeDir}/Bilder";
        devices = [
          "T480"
          "PC"
        ];
      };
    };
  };
}
