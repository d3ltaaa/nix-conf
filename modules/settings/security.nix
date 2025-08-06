{ ... }:
{
  imports = [
    ./security/fail2ban.nix
    ./security/integrity.nix
    ./security/networking.nix
    ./security/passwordManager.nix
  ];
}
