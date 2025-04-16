{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/configuration.nix
    ./../../modules/packages.nix
    ./../../modules/virtualisation.nix
    ./../../modules/ai.nix
    ./../../modules/amdgpu.nix
    ./../../modules/syncthing.nix
  ];

  networking.hostName = "PC";

  # enable modules
  configuration-module.enable = true;
  packages-module.enable = true;

  virtualisation-module.enable = true;
  amdgpu-module.enable = true;
  syncthing-module.enable = true;

  # enable options
  ai-packages.enable = true;
  os-prober-option.enable = true;

}
