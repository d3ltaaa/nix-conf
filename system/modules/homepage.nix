{
  lib,
  config,
  ...
}:
{
  options = {
    homepage-module.enable = lib.mkEnableOption "Enables Homepage module";
  };
  config = lib.mkIf config.homepage-module.enable {
    services.homepage-dashboard = {
      enable = true;
      allowedHosts = "192.168.2.12:8082,home.d3lta.ipv64.net";
      openFirewall = true;
      services = [
        {
          "Administration" = [
            {
              "Proxmox" = {
                href = "https://proxmox.d3lta.ipv64.net";
              };
            }
          ];
        }
        {
          "Services" = [
            {
              "Vaultwarden" = {
                href = "https://vault.d3lta.ipv64.net";
              };
            }
          ];
        }
        {
          "Devices" = [
            {
              "Router" = {
                href = "http://192.168.2.1";
              };
              "3D Printer" = {
                href = "https://dp.d3lta.ipv64.net";
              };
            }
          ];
        }
      ];
    };
  };
}
