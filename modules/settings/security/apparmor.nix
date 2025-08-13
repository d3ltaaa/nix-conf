{ pkgs, ... }:
{
  # Load the firejail-default AppArmor profile at boot
  security.apparmor = {
    enable = true;
  };
  security.apparmor.policies.firejail = {
    profile = "${pkgs.firejail}/etc/apparmor.d/firejail-default";
  };
}
