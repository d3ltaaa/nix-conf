{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/configuration.nix
    ./../../modules/packages.nix
    ./../../modules/virtualisation.nix
    ./../../modules/ai.nix
  ];

  networking.hostName = "PC";

  # enable modules
  configuration-module.enable = true;
  packages-module.enable = true;
  virtualisation-module.enable = true;
  ai-packages.enable = true;
}
