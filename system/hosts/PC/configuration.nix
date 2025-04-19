{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/default.nix
  ];

  networking.hostName = "PC";

  # enable modules
  bootloader-module.enable = true;
  os-prober-option.enable = true;

  locale-module.enable = true;

  user-module.enable = true;

  packages-module.enable = true;

  environment-module.enable = true;

  connections-module.enable = true;

  syncthing-module.enable = true;

  # specific
  brightness-module.enable = true;
  monitortype-option = "external";

  amdgpu-module.enable = true;

  ai-module.enable = true;

  virtualisation-module.enable = true;
  vbox-options.enable = true;
  kvmqemu-options.enable = true;

  nvidiagpu-module.enable = false;
  enable-nvidia-option = false;
}
