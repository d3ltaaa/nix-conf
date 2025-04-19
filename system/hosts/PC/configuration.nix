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

  packages-module.enable = true;

  programs-module.enable = true;

  services-module.enable = true;

  environment-module.enable = true;

  connections-module.enable = true;

  syncthing-module.enable = true;

  # specific
  brightness-module.enable = true;
  brightness-module.monitorType = "external";

  amdgpu-module.enable = true;

  ai-module.enable = true;

  virtualisation-module.enable = true;
  virtualisation-module.vbox.enable = true;
  virtualisation-module.kvmqemu.enable = true;

  nvidiagpu-module.enable = false;
  nvidiagpu-module.enableGpu = false;
}
