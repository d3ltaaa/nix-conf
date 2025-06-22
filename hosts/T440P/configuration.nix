{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/default.nix
  ];

  networking.hostName = "T440P";

  # enable modules
  bootloader-module.enable = true;
  bootloader-module.os-prober.enable = false;

  locale-module.enable = true;

  user-module.enable = true;

  packages-module.enable = true;

  programs-module.enable = true;

  services-module.enable = true;

  environment-module.enable = true;

  connections-module.enable = true;

  syncthing-module.enable = true;

  theme-module.enable = true;

  # specific
  brightness-module.enable = true;
  brightness-module.monitorType = "internal";

  amdgpu-module.enable = false;

  ai-module.enable = false;

  virtualisation-module.enable = false;
  virtualisation-module.vbox.enable = false;
  virtualisation-module.kvmqemu.enable = false;

  nvidiagpu-module.enable = false;
  nvidiagpu-module.enableGpu = false;
}
