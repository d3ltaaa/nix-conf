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
          stateDir = "/mnt/share/open-webui/stateDir";
        };

        systemd.services.open-webui.serviceConfig = {
          ReadWritePaths = [ "${config.services.open-webui.stateDir}" ];
        };

        services.ollama = {
          enable = true;
          package = pkgs.ollama-rocm;
          user = "ollama";
          models = "/mnt/share/ollama/models";
          home = "/mnt/share/ollama/home";
          acceleration = "rocm";
          rocmOverrideGfx = "11.0.0"; # 7900xt (gpu-family)
          loadModels = [
            "mistral"
          ];
        };

        # match uid on systems
        users.users.ollama = {
          uid = 995;
        };

        systemd.services.ollama = {
          after = lib.mkIf config.amdgpu-module.enable [
            "lact.service"
          ];
          serviceConfig = {
            ReadWritePaths = [
              "${config.services.ollama.models}"
              "${config.services.ollama.home}"
            ];
          };
        };

        systemd.services.ollama-model-loader.serviceConfig = {
          ReadWritePaths = [
            "${config.services.ollama.models}"
            "${config.services.ollama.home}"
          ];
        };

        # users.groups.ollama.members = [ "${variables.user}" ];
      };
}
