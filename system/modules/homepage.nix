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
      bookmarks = [
        {
          "Bookmarks" = [
            {
              "Proton Mail" = [
                {
                  icon = "proton-mail.png";
                  href = "https://mail.proton.me/u/0/inbox";
                }
              ];
            }
            {
              "Proton Calendar" = [
                {
                  icon = "proton-calendar.png";
                  href = "https://calendar.proton.me/u/0/";
                }
              ];
            }
            {
              "Github" = [
                {
                  icon = "github-light.png";
                  href = "https://github.com/";
                }
              ];
            }
            {
              "Youtube" = [
                {
                  icon = "youtube.png";
                  href = "https://youtube.com/";
                }
              ];
            }
            {
              "ChatGPT" = [
                {
                  icon = "chatgpt.png";
                  href = "https://chat.openai.com/chat";
                }
              ];
            }
            {
              "HM4Mint" = [
                {
                  icon = "bookstack.png";
                  href = "https://hm4mint.nrw/hm1/link/HoeherMathem1";
                }
              ];
            }
          ];
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
            {
              "Wireguard" = {
                icon = "wireguard.png";
                href = "https://wg.d3lta.ipv64.net";
              };
            }
          ];
        }
        {
          "Services" = [
            {
              "Syncthing" = {
                icon = "syncthing.png";
                href = "https://syncthing.d3lta.ipv64.net";
              };
            }
            {
              "Vaultwarden" = {
                icon = "vaultwarden.png";
                href = "https://vault.d3lta.ipv64.net";
              };
            }
            {
              "Homeassistant" = {
                icon = "home-assistant.png";
                href = "https://homeassistant.d3lta.ipv64.net";
              };
            }
            {
              "Ollama/Open-Webui" = {
                icon = "ollama.png";
                href = "https://ollama.d3lta.ipv64.net";
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
