{
  lib,
  config,
  nixpkgs-stable,
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
      name = "PC-SERVER";
      nixosStateVersion = "25.05";
      homeManagerStateVersion = "25.05";
      language = "en";
      timeZone = "Europe/Berlin";
      keyboardLayout = "de";
      environment.enable = true;
      serverAddress = serverAddress;
    };

    desktop = {
      autoLogin.enable = false;
      autoShutdown = {
        enable = true;
        watchPort = "11434"; # ollama port
        shutdownTime = "1800"; # seconds
      };
      windowManager.hyprland = {
        enable = false;
        monitor = [
          "DP-3, 2560x1440@240, 0x0, 1"
          "DP-2, 1920x1080@165, 2560x0, 1"
        ];
        workspaces = [
          "1, monitor:DP-3"
          "3, monitor:DP-3"
          "5, monitor:DP-3"
          "7, monitor:DP-3"
          "9, monitor:DP-3"
          "2, monitor:DP-2"
          "4, monitor:DP-2"
          "6, monitor:DP-2"
          "8, monitor:DP-2"
        ];
      };
      screenLock.hypridle.enable = false;
    };

    users = {
      primary = "falk";
    };

    boot = {
      primaryBoot = false;
      osProber = false;
      defaultEntry = 0;
      extraEntries = '''';
    };

    networking = {
      role = "server";
      lanInterface = "eno1";
      wifiInterface = null;
      staticIp = "192.168.2.30";
      defaultGateway = "192.168.2.1";
      nameservers = [
        "192.168.2.11"
        "1.1.1.1"
      ];
      wakeOnLan = true;
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
            tool = true;
            hypr = false;
            desk = false;
            power = true;
          };
          user.default = false;
          font.default = false;
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
      dconf.enable = true;
      firefox.enable = false;
      spotify.enable = false;
      virtualisation = {
        vbox.enable = false;
        kvmqemu.enable = false;
      };
      ollama-server = {
        enable = true;
        dualSetup = true;
        modelDir = "/mnt/share/ollama/models";
        homeDir = "/mnt/share/ollama/home";
      };
      open-webui-client = {
        enable = false;
      };
      open-webui-server = {
        enable = false;
        # prefix = "ollama.${serverAddress}";
        # stateDir = null;
      };
      vaultwarden-server = {
        enable = false;
        # prefix = "vault.${serverAddress}";
        # role = "client";
      };
      wireguard-client = {
        enable = false;
        address = [ "10.100.0.2/32" ];
        dns = [
          "192.168.2.11"
          "192.168.2.1"
        ];
        serverPublicKey = "hAvazVD4FMIbtZPLa5rtUXrZ3iXYIiW5Ivemyv1UmWA=";
      };
      wireguard-server = {
        enable = false;
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
      homeassistant-server = {
        enable = false;
      };
      homepage-server = {
        enable = false;
      };
      fileSharing-client = {
        enable = false;
        items = [
          {
            share = {
              "/mnt/private" = {
                device = "//192.168.2.12/private";
              };
            };
          }
        ];
      };
      fileSharing-server = {
        enable = false;
        ip = "192.168.2.12";
        items = [
          {
            share = {
              private = {
                path = "/mnt/shared/private";
                "force user" = "falk";
                "force group" = "users";
              };
            };
          }
        ];
      };
      acme-server = {
        enable = false;
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
        enable = false;
        address = [
          "/${config.settings.general.serverAddress}/192.168.2.11"
        ];
      };
      nginx-server = {
        enable = false;
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
      };
      syncthing = {
        enable = false;
        devices = {
          "PX8".id = "UPROPYX-AFK4Q5X-P5WRKRE-4VXJ5XU-QKTXML3-2SFWBV7-ELVVPDH-AOWS2QY";
          "T480".id = "Z3EA4H3-RNVAKPJ-JIWF4HD-L4AISEX-DUZZ4SV-P3E45GU-AKA3DHG-VYQNRAK";
          "T440P".id = "CAWY2HI-K3QLENX-QABH4C4-QDGBZAB-GH22BRL-ZB6YBG5-PXVDZTR-4MSF7QY";
          "SERVER".id = "OP5RCKE-UFEQ4IT-DRMANC2-425AFHE-RS4PG3Y-35VLH6F-7UJXUIJ-EAVK5A3";
        };

        folders = {
          "Dokumente" = {
            path = "/home/${config.settings.users.primary}/Dokumente";
            devices = [
              "T480"
              "T440P"
              "SERVER"
            ];
          };
          "Bilder" = {
            path = "/home/${config.settings.users.primary}/Bilder";
            devices = [
              "T480"
              "T440P"
              "SERVER"
            ];
          };
        };
      };

      # home-manager
      neovim.enable = true;
      foot.enable = false;
      dunst.enable = false;
      lf.enable = true;
      rofi.enable = false;
      tmux.enable = true;
      waybar.enable = false;
      swappy.enable = false;
    };
  };

  hardware = {
    blueTooth.enable = false;
    tablet.enable = false;
    powerManagement = {
      upower.enable = true;
      tlp.enable = true;
      auto-cpufreq = {
        enable = true;
        thresholds = false;
      };
    };
    printing = {
      enable = false;
      printer.ML-1865W.enable = true;
      installDriver = {
        general = true;
        hp = true;
        samsung = true;
      };
    };
    audio.enable = true;
    usb.enable = true;
    brightness = {
      enable = true;
      monitorType = "external";
    };
    nvidiaGpu = {
      enable = false;
      # enableGpu = false;
      # intelBusId = "PCI:0@0:2:0";
      # nvidiaBusId = "PCI:0@01:0:0";
    };
    amdGpu.enable = true;
  };
}
