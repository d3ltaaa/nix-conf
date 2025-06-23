{ lib, config, ... }:
{
  options = {
    applications.configuration.ssh.enable = lib.mkEnableOption "Enables ssh";
  };
  config = {
    services.openssh.enable = config.applications.configuration.ssh.enable;
  };
}
