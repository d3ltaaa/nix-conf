{ ... }:
{
  imports = [
    ./security/networking.nix
    ./security/passwordManager.nix
    ./security/fail2ban.nix
  ];
}
