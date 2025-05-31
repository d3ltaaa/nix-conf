{ ... }:
{
  imports = [
    ./ai.nix
    ./amdgpu.nix
    ./autoShutdown.nix
    ./brightness.nix
    ./bootloader.nix
    ./connections.nix
    ./environment.nix
    ./flatpaks.nix
    ./general.nix
    ./homeassistant.nix
    ./homepage.nix
    ./locale.nix
    ./nvidiagpu.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./syncthing.nix
    ./theme.nix
    ./fileSharing.nix
    ./user.nix
    ./virtualisation.nix
    ./wireguard.nix
    ./vaultwarden.nix
  ];
}
