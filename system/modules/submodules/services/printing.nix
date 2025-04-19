{ ... }:
{
  services = {
    printing = {
      enable = true;
      drivers = [ ];
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
    # ensurePrinters = [
    #
    # ];
  };
}
