{ lib, config, ... }:
{
  options = {
    applications.configuration.ssh.enable = lib.mkEnableOption "Enables ssh";
  };
  config = {
    services.openssh.enable = lib.mkIf config.applications.configuration.ssh;
  };
}
