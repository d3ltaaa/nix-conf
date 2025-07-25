{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    hardware.printing = {
      enable = lib.mkEnableOption "Enables printing module";
      printer.ML-1865W.enable = lib.mkEnableOption "Enables configuration for ML-1865W";
      installDriver = {
        general = lib.mkEnableOption "Installs general drivers";
        hp = lib.mkEnableOption "Installs hp drivers";
        samsung = lib.mkEnableOption "Installs samsung drivers";
      };
    };
  };

  config = lib.mkIf config.hardware.printing.enable {
    services = {
      printing = {
        drivers =
          with pkgs;
          [ ]
          ++ (pkgs.lib.optionals config.hardware.printing.installDriver.general gutenprint)
          ++ (pkgs.lib.optionals config.hardware.printing.installDriver.hp hplip splix)
          ++ (pkgs.lib.optionals config.hardware.printing.installDriver.samsung samsung-unified-linux-driver);

        # auto discovery of network printers
      };
      avahi = {
        nssmdns4 = true;
        openFirewall = true;
      };
    };
    hardware.printers = {
      ensurePrinters = lib.mkIf config.hardware.printing.printer.ML-1865W.enable [
        {
          name = "Samsung_ML-1865W_Series";
          location = "Home";
          deviceUri = "usb://Samsung/ML-1865W%20Series?serial=Z5IRBKBZC00605L";
          model = "samsung/ML-1865W.ppd";
          ppdOptions = {
            PageSize = "A4";
          };
        }
      ];
    };
  };
}
