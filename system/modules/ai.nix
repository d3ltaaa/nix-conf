{
  pkgs,
  lib,
  config,
  variables,
  ...
}:
{
  options = {
    ai-module.enable = lib.mkEnableOption "Enable Ai module";
  };
  config =
    lib.mkIf
      (
        config.ai-module.enable == true
        && (config.networking.hostName == "PC" || config.networking.hostName == "PC-SERVER")
      )
      {

        services.open-webui = {
          enable = true;
          package = pkgs.open-webui;
          host = "0.0.0.0";
          openFirewall = true;
          stateDir = "/mnt/share/ollama/webui/stateDir";
        };

        systemd.services.open-webui.serviceConfig = {
          DynamicUser = true;
          ReadWritePaths = [ "${config.services.open-webui.stateDir}" ];
        };

        services.ollama = {
          enable = true;
          package = pkgs.ollama-rocm;
          user = "ollama";
          group = "ollama";
          models = "/mnt/share/ollama/models";
          home = "/mnt/share/ollama/home";
          acceleration = "rocm";
          rocmOverrideGfx = "11.0.0"; # 7900xt (gpu-family)
          loadModels = [
            "gemma3:27b"
            "mistral"
          ];
        };

        systemd.services.ollama.serviceConfig = {
          DynamicUser = true;
          ReadWritePaths = [
            "${config.services.ollama.models}"
            "${config.services.ollama.home}"
          ];
        };

        users.groups.ollama.members = [ "${variables.user}" ];
      };
}
