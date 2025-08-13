{ ... }:
{
  imports = [
    ./security/apparmor.nix
    ./security/fail2ban.nix
    ./security/firejail.nix
    ./security/integrity.nix
    ./security/networking.nix
    ./security/passwordManager.nix
  ];
}
