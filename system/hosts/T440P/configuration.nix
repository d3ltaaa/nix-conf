{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/configuration.nix
    ./../../modules/packages.nix
    ./../../modules/virtualisation.nix
    ./../../modules/ai.nix
  ];

  networking.hostName = "T440P";

  # enable modules
  configuration-module.enable = true;
  packages-module.enable = true;
  virtualisation-module.enable = false;
  ai-packages.enable = false;

}
