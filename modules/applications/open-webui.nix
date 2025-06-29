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
    applications.configuration.open-webui-client = {
      enable = lib.mkEnableOption "Enables Open-webui module";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf config.applications.configuration.open-webui-server.enable {
      environment.systemPackages = [
        pkgs.python313Packages.hf-xet
      ];
      services.open-webui = {
        enable = true;
        package = pkgs.open-webui;
        host = "0.0.0.0";
        openFirewall = true;
      };
    })
    (lib.mkIf config.applications.configuration.open-webui-client.enable {
      home-manager.users.${config.settings.users.primary} =
        let
          nixos-config = config;
        in
        { config, ... }:
        {
          xdg.desktopEntries.open-webui = {
            name = "Open-Webui";
            exec = "firefox --new-window ollama.${nixos-config.settings.general.serverAddress}";
            startupNotify = false;
            terminal = false;
            icon = "openai";
          };
        };
    })
  ];
}
