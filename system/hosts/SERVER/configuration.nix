{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/default.nix
  ];

  networking.hostName = "SERVER";

  # enable modules
  bootloader-module.enable = true;
  bootloader-module.os-prober.enable = false;

  locale-module.enable = true;

  user-module.enable = true;

  packages-module = {
    enable = true;
    system = {
      stable = false;
      unstable = false;
      unstable-base = true;
      unstable-lang = true;
      unstable-tool = true;
      unstable-hypr = false;
      unstable-desk = false;
      unstable-power = false;
      derivations = true;
    };
    user = {
      stable = false;
      unstable = false;
    };
    fonts = {
      stable = false;
      unstable = true;
    };
  };

  programs-module = {
    enable = true;
    programs = {
      hyprland = false;
      zsh = true;
      thunar = false;
      dconf = true;
      git = true;
    };
  };

  services-module = {
    enable = true;
    services = {
      powerManagement = false;
      audio = false;
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
  };

  syncthing-module.enable = true;

  theme-module.enable = false;

  brightness-module = {
    enable = false;
    monitorType = "external";
  };

  amdgpu-module.enable = false;

  ai-module.openWebui.enable = true;
  ai-module.ollama.enable = false;

  virtualisation-module = {
    enable = false;
    vbox.enable = false;
    kvmqemu.enable = false;
  };

  nvidiagpu-module = {
    enable = false;
    enableGpu = true;
  };

  wireguard-module.enable = false;

  fileSharing-module = {
    enable = true;
    type = "server";
  };

  vaultWarden-module = {
    enable = true;
    type = "server";
  };

  homepage-module.enable = true;

  homeassistant-module.enable = true;
}
