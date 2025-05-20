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
      widgets = [
        {
          resources = {
            cpu = true;
            disk = "/";
            memory = true;
          };
        }
        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };
        }
      ];
      services = [
        {
          "Administration" = [
            {
              "Proxmox" = {
                icon = "proxmox.png";
                href = "https://proxmox.d3lta.ipv64.net";
              };
            }
          ];
        }
        {
          "Services" = [
            {
              "Vaultwarden" = {
                icon = "vaultwarden.png";
                href = "https://vault.d3lta.ipv64.net";
              };
            }
            {
              "Wireguard" = {
                icon = "wireguard.png";
                href = "https://wg.d3lta.ipv64.net";
              };
            }
          ];
        }
        {
          "Devices" = [
            {
              "Router" = {
                icon = "router.png";
                href = "http://192.168.2.1";
              };
            }
            {
              "3D Printer" = {
                icon = "mainsail.png";
                href = "https://dp.d3lta.ipv64.net";
              };
            }
          ];
        }
      ];
    };
  };
}
