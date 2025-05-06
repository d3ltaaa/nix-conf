{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/default.nix
  ];

  networking.hostName = "WIREGUARD-SERVER";

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
      unstable-lang = false;
      unstable-tool = false;
      unstable-hypr = false;
      unstable-desk = false;
      unstable-power = false;
      derivations = false;
    };
    user = {
      stable = false;
      unstable = false;
    };
    fonts = {
      stable = false;
      unstable = false;
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
      printing = false;
      usb = true;
      login = true;
    };
  };

  flatpak-module.enable = false;

  environment-module.enable = true;

  connections-module.enable = true;

  syncthing-module.enable = false;

  theme-module.enable = false;

  brightness-module = {
    enable = false;
    monitorType = "external";
  };

  amdgpu-module.enable = false;

  ai-module.enable = false;

  virtualisation-module = {
    enable = false;
    vbox.enable = false;
    kvmqemu.enable = false;
  };

  nvidiagpu-module = {
    enable = false;
    enableGpu = true;
  };

  wireguard-module.enable = true;

  fileSharing-module.enable = false;

}
