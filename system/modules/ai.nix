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
  config = lib.mkIf (config.ai-module.enable == true && config.networking.hostName == "PC") {

    services.open-webui = {
      enable = true;
      # port = 8080;
      package = pkgs.open-webui;
      host = "0.0.0.0";
      openFirewall = true;
      # stateDir = "/mnt/share/";
    };
    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      acceleration = "rocm";
      user = "ollama";
      group = "ollama";
      rocmOverrideGfx = "11.0.0"; # 7900xt (gpu-family)
      loadModels = [
        "gemma3:27b"
        "mistral"
      ];
    };
    users.groups.ollama.members = [ "${variables.user}" ];
  };
}
