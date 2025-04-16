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

  # PC
  virtualisation-module.enable = true;
  amdgpu-module.enable = true;
  syncthing-module.enable = true;
  ai-packages.enable = true;
}
