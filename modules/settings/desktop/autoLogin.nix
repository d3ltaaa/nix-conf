{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    settings.desktop = {
      autoLogin.enable = lib.mkEnableOption "Enables AutoLogin";
    };
  };
  config = {
    services = {
      getty.autologinUser = lib.mkIf config.settings.desktop.autoLogin.enable "${config.settings.users.primary
      }";
    };
  };
}
