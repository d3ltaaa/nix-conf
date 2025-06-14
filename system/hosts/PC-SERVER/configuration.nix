{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/default.nix
  ];

  networking.hostName = "PC-SERVER";

  # enable modules
  bootloader-module = {
    enable = true;
    os-prober.enable = false;
    secondaryOs = true;
  };

  locale-module.enable = true;

  user-module.enable = true;

  packages-module = {
    enable = true;
    system = {
      stable = true;
      unstable = true;
      unstable-base = true;
      unstable-lang = true;
      unstable-tool = true;
      unstable-hypr = false;
      unstable-desk = false;
      unstable-power = true;
      derivations = false;
    };
    user = {
      stable = true;
      unstable = true;
    };
    fonts = {
      stable = true;
      unstable = true;
    };
  };

  programs-module = {
    enable = true;
    programs = {
      hyprland = false;
      zsh = true;
      thunar = true;
      dconf = true;
      git = true;
    };
  };

  services-module = {
    enable = true;
    services = {
      powerManagement = true;
      audio = true;
      printing = true;
      usb = true;
      login = true;
    };
  };

  flatpak-module.enable = false;

  environment-module.enable = true;

  connections-module = {
    enable = true;
    type = "client";
    ssh = true;
  };

  syncthing-module.enable = false;

  theme-module.enable = false;

  brightness-module = {
    enable = false;
    monitorType = "external";
  };

  amdgpu-module.enable = true;

  ai-module.ollama.enable = true;
  ai-module.openWebui.enable = false;

  virtualisation-module = {
    enable = true;
    vbox.enable = true;
    kvmqemu.enable = false;
  };

  nvidiagpu-module = {
    enable = false;
    enableGpu = false;
  };

  wireguard-module.enable = false;

  fileSharing-module = {
    enable = false;
    type = "client";
  };

  autoShutdown-module = {
    enable = true;
    watchPort = "11434";
  };
}
