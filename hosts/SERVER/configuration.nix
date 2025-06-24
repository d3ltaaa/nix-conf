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
      name = "SERVER";
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
      windowManager.hyprland.enable = false;
      screenLock.hypridle.enable = true;
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
      staticIp = "192.168.2.12";
      defaultGateway = "192.168.2.1";
      nameservers = [
        "192.168.2.11"
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
      dconf.enable = true;
      open-webui-server.enable = true;
      vaultwarden-server.enable = true;
      homeassistant-server.enable = true;
      homepage-server.enable = true;
      fileSharing-server = {
        enable = true;
        ip = "192.168.2.12";
        items = [
          {
            share = {
              private = {
                path = "/mnt/shared/private";
                "valid user" = "falk";
                "force user" = "falk";
                "force group" = "user";
              };
            };
          }
        ];
      };
      syncthing = {
        enable = true;
        gui = true;
        devices = {
          "PC".id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
          "PX8".id = "UPROPYX-AFK4Q5X-P5WRKRE-4VXJ5XU-QKTXML3-2SFWBV7-ELVVPDH-AOWS2QY";
          "T480".id = "Z3EA4H3-RNVAKPJ-JIWF4HD-L4AISEX-DUZZ4SV-P3E45GU-AKA3DHG-VYQNRAK";
          "T440P".id = "CAWY2HI-K3QLENX-QABH4C4-QDGBZAB-GH22BRL-ZB6YBG5-PXVDZTR-4MSF7QY";
          # "SERVER".id = "OP5RCKE-UFEQ4IT-DRMANC2-425AFHE-RS4PG3Y-35VLH6F-7UJXUIJ-EAVK5A3";
        };
        folders = {
          "Dokumente" = {
            path = "/mnt/syncthing/Dokumente";
            devices = [
              "T480"
              "PC"
              "T440P"
            ];
          };
          "Bilder" = {
            path = "/mnt/syncthing/Bilder";
            devices = [
              "T480"
              "PC"
              "T440P"
            ];
          };
          "PX8/DCIM" = {
            path = "/mnt/shared/private/sync/PX8/DCIM";
            devices = [
              "PX8"
            ];
          };
          "PX8/Dokumente" = {
            path = "/mnt/shared/private/sync/PX8/Dokumente";
            devices = [
              "PX8"
            ];
          };
        };
      };
      ssh.enable = true;

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
