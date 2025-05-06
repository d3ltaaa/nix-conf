{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/default.nix
  ];

  networking.hostName = "PC";

  # enable modules
  bootloader-module.enable = true;
  bootloader-module.os-prober.enable = true;

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
      unstable-hypr = true;
      unstable-desk = true;
      unstable-power = true;
      derivations = true;
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
      hyprland = true;
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

  flatpak-module.enable = true;

  environment-module.enable = true;

  connections-module.enable = true;

  syncthing-module.enable = true;

  theme-module.enable = true;

  brightness-module = {
    enable = true;
    monitorType = "external";
  };

  amdgpu-module.enable = true;

  ai-module.enable = true;

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
    enable = true;
    type = "client";
  };
}
