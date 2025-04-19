{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/default.nix
  ];

  networking.hostName = "T440P";

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
  monitortype-option = "internal";

  amdgpu-module.enable = false;

  ai-module.enable = false;

  virtualisation-module.enable = false;
  vbox-options.enable = false;
  kvmqemu-options.enable = false;

  nvidiagpu-module.enable = false;
  enable-nvidia-option = false;
}
