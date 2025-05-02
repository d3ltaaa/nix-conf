{
  pkgs,
  config,
  lib,
  ...
}:
{
  services = {
    printing = {
      drivers = with pkgs; [
        gutenprint
        hplip
        splix
        samsung-unified-linux-driver
      ];
    };

    # auto discovery of network printers
    avahi = {
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  hardware.printers = lib.mkIf config.services-module.services.printing {
    ensurePrinters = [
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
}
