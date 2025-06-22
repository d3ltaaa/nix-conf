{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configuration.open-webui-server = {
      enable = lib.mkEnableOption "Enables Open-webui module";
    };
  };
  config = lib.mkIf config.applications.configuration.open-webui-server.enable {
    environment.systemPackages = [
      pkgs.python313Packages.hf-xet
    ];
    services.open-webui = {
      enable = true;
      package = pkgs.open-webui;
      host = "0.0.0.0";
      openFirewall = true;
    };
  };
}
