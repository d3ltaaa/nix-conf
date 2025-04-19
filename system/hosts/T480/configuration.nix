{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/default.nix
  ];

  networking.hostName = "T480"; # Define your hostname.

  # enable modules
  bootloader-module.enable = true;
  bootloader-module.os-prober.enable = falsfalsee;

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
  brightness-module.monitorType = "internal";

  amdgpu-module.enable = false;

  ai-module.enable = false;

  virtualisation-module.enable = true;
  virtualisation-module.vbox.enable = true;
  virtualisation-module.kvmqemu.enable = false;

  nvidiagpu-module.enable = true;
  nvidiagpu-module.enableGpu = false;

  specialisation = {
    nvidia-enable.configuration = {
      nvidiagpu-module.enableGpu = lib.mkForce true;
    };
  };
}
