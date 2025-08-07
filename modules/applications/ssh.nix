{ lib, config, ... }:
{
  options = {
    applications.configuration.ssh.enable = lib.mkEnableOption "Enables ssh";
  };
  config = lib.mkIf config.applications.configuration.ssh.enable {
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };
}
