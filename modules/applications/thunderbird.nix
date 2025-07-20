{ lib, config, ... }:
{
  options = {
    applications.configuration.thunderbird.enable = lib.mkEnableOption "Enables Thunderbird";
  };
  config = lib.mkIf config.applications.configuration.thunderbird.enable {
    programs.thunderbird = {
      enable = true;
      preferencesStatus = "user";
    };
  };
}
