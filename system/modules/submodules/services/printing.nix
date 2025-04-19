{ pkgs, ... }:
{
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        hplip
        splix
        samsung-unified-linux-driver
      ];
    };

    # auto discovery of network printers
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # smbd protocol
    samba.enable = true;
  };

  hardware.printers = {
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
