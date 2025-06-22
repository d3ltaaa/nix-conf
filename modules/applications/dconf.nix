{ lib, config, ... }:
{
  options = {
    applications.configuration.dconf.enable = lib.mkEnableOption "Enables dconf module";
  };
  config = lib.mkIf config.applications.configuration.dconf.enable {
    programs.dconf.enable = true;
  };
}
