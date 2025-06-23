{
  lib,
  config,
  ...
}:
let
  serverAddress = lib.strings.trim (builtins.readFile "/etc/credentials/server_address");
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  settings = {
    general = {
      name = "WIREGUARD-SERVER";
      nixosStateVersion = "25.05";
      homeManagerStateVersion = "25.05";
      language = "en";
      timeZone = "Europe/Berlin";
      keyboardLayout = "de";
      environment.enable = true;
      serverAddress = serverAddress;
    };

    desktop = {
      autoLogin.enable = true;
      windowManager.hyprland = {
        enable = false;
      };
      screenLock.hypridle.enable = false;
    };

    users = {
      primary = "falk";
    };

    boot = {
      primaryBoot = true;
      osProber = false;
      defaultEntry = 1;
      extraEntries = null;
    };

    networking = {
      role = "server";
      lanInterface = "ens18";
      wifiInterface = null;
      staticIp = "192.168.2.11";
      defaultGateway = "192.168.2.1";
      nameservers = [
        "1.1.1.1"
      ];
    };
  };

  applications = {
    packages = {
      libraries = {
        unstable = {
          system.default = true;
          system = {
            base = true;
            lang = false;
            tool = false;
            hypr = false;
            desk = false;
            power = false;
          };
          user.default = false;
          font.default = true;
        };
        stable = {
          system.default = false;
          user.default = false;
          font.default = false;
        };
        flatpaks.default = false;
        derivations.default = false;
      };
    };
    configuration = {
      # nixos
      git = {
        enable = true;
        username = "d3ltaaa";
        email = "hil.falk@protonmail.com";
      };
      zsh.enable = true;
      thunar.enable = false;
      dconf.enable = false;
      virtualisation = {
        vbox.enable = false;
        kvmqemu.enable = false;
      };
      ollama-server.enable = false;
      open-webui-server.enable = false;
      vaultwarden-server.enable = false;
      wireguard-client.enable = false;
      wireguard-server = {
        enable = true;
        serverPeers = [
          {
            # T480
            publicKey = "fSaTvwFYNcAx/dKxS9HCEB/017HITk/dpZCwJ1uZDDs=";
            allowedIPs = [ "10.100.0.2/32" ];
          }
          {
            # PHONE
            publicKey = "Am+PSLEvczLPxaoI/x2QEiQCe1N5/LwSzVqPD/CUDF4=";
            allowedIPs = [ "10.100.0.3/32" ];
          }
          {
            # TABS9
            publicKey = "Ggovi9VYVEHK70enoT/8/GweGBTX8xgiktRTMSGboww=";
            allowedIPs = [ "10.100.0.4/32" ];
          }
        ];
      };
      homeassistant-server.enable = false;
      homepage-server.enable = false;
    };
    fileSharing-client.enable = true;
    fileSharing-server.enable = false;
    acme-server = {
      enable = true;
      domain = "${serverAddress}";
      email = "hil.falk@protonmail.com";
      dnsProvider = "ipv64";
      domainNames = [
        "dp.${serverAddress}"
        "proxmox.${serverAddress}"
        "vault.${serverAddress}"
        "home.${serverAddress}"
        "wg.${serverAddress}"
        "homeassistant.${serverAddress}"
        "ollama.${serverAddress}"
        "syncthing.${serverAddress}"
      ];
    };
    dnsmasq-server = {
      enable = true;
      address = [
        "/${config.settings.general.serverAddress}/192.168.2.11"
      ];
    };
    nginx-server = {
      enable = true;
      virtualHosts = {
        "proxmox.${serverAddress}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "https://192.168.2.10:8006";
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 8G;
              proxy_buffering off;
              proxy_request_buffering off;
              proxy_connect_timeout 3600;
              proxy_send_timeout 3600;
              proxy_read_timeout 3600;
            '';
          };
        };
        "dp.${serverAddress}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://192.168.2.31:80"; # allow dp.${serverAddress} in moonraker manually
            proxyWebsockets = true;
          };
        };
        "vault.${serverAddress}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://192.168.2.12:8222";
            proxyWebsockets = true;
          };
        };
        "home.${serverAddress}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://192.168.2.12:8082";
            proxyWebsockets = true;
          };
        };
        "wg.${serverAddress}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://192.168.2.11:5000";
            proxyWebsockets = true;
          };
        };
        "homeassistant.${serverAddress}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://192.168.2.12:8123";
            proxyWebsockets = true;
          };
        };
        "ollama.${serverAddress}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://192.168.2.12:8080";
            proxyWebsockets = true;
          };
        };
        "syncthing.${serverAddress}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://192.168.2.12:8384";
            proxyWebsockets = true;
          };
        };
      };
      syncthing.enable = false;

      # home-manager
      neovim.enable = true;
      foot.enable = true;
      dunst.enable = true;
      lf.enable = true;
      rofi.enable = true;
      tmux.enable = true;
      waybar.enable = true;
      swappy.enable = true;
    };
  };

  hardware = {
    tablet.enable = false;
    powerManagement = {
      upower.enable = false;
      tlp.enable = false;
      auto-cpufreq = {
        enable = false;
        thresholds = false;
      };
    };
    printing = {
      enable = false;
      printer.ML-1865W.enable = false;
      installDriver = {
        general = false;
        hp = false;
        samsung = false;
      };
    };
    audio.enable = false;
    usb.enable = false;
    brightness = {
      enable = false;
      monitorType = "external";
    };
    nvidiaGpu = {
      enable = false;
      # enableGpu = false;
      # intelBusId = "PCI:0@0:2:0";
      # nvidiaBusId = "PCI:0@01:0:0";
    };
    amdGpu.enable = false;
  };
}
