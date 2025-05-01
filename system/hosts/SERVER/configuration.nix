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

  packages-module.enable = false;

  programs-module.enable = false;

  services-module.enable = false;

  environment-module.enable = true;

  connections-module.enable = false;

  syncthing-module.enable = false;

  theme-module.enable = false;

  # specific
  brightness-module.enable = false;
  # brightness-module.monitorType = "external";

  amdgpu-module.enable = false;

  ai-module.enable = false;

  virtualisation-module.enable = false;
  virtualisation-module.vbox.enable = false;
  virtualisation-module.kvmqemu.enable = false;

  nvidiagpu-module.enable = false;
  nvidiagpu-module.enableGpu = false;
  
  environment.systemPackages = with pkgs; [
    git
    vim
  ];
}
