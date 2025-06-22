{
  lib,
  config,
  ...
}:
{
  options = {
    applications.configuration.homepage-server.enable = lib.mkEnableOption "Enables Homepage module";
  };
  config = lib.mkIf config.applications.configuration.homepage-server.enable {
    services.homepage-dashboard = {
      enable = true;
      allowedHosts = "home.${config.settings.general.serverAddress}";
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
                href = "https://proxmox.${config.settings.general.serverAddress}";
              };
            }
            {
              "Wireguard" = {
                icon = "wireguard.png";
                href = "https://wg.${config.settings.general.serverAddress}";
              };
            }
          ];
        }
        {
          "Services" = [
            {
              "Syncthing" = {
                icon = "syncthing.png";
                href = "https://syncthing.${config.settings.general.serverAddress}";
              };
            }
            {
              "Vaultwarden" = {
                icon = "vaultwarden.png";
                href = "https://vault.${config.settings.general.serverAddress}";
              };
            }
            {
              "Homeassistant" = {
                icon = "home-assistant.png";
                href = "https://homeassistant.${config.settings.general.serverAddress}";
              };
            }
            {
              "Ollama/Open-Webui" = {
                icon = "ollama.png";
                href = "https://ollama.${config.settings.general.serverAddress}";
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
                href = "https://dp.${config.settings.general.serverAddress}";
              };
            }
          ];
        }
      ];
    };
  };
}
