{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/default.nix
  ];

  networking.hostName = "PC-SERVER";

  # enable modules
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  bootloader-module.enable = false;
  bootloader-module.os-prober.enable = false;
  # changes
  boot.loader.grub.useOSProber = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

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
    enable = false;
    type = "client";
  };

  syncthing-module.enable = false;

  theme-module.enable = false;

  brightness-module = {
    enable = false;
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
    enable = false;
    type = "client";
  };
}
