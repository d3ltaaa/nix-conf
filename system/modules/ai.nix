{
  pkgs,
  lib,
  config,
  variables,
  ...
}:
{
  options = {
    ai-module.ollama.enable = lib.mkEnableOption "Enable Ollama module";
    ai-module.openWebui.enable = lib.mkEnableOption "Enable OpenWebui module";
  };
  config = {

    environment.systemPackages = lib.mkIf config.ai-module.openWebui.enable [
      pkgs.python313Packages.hf-xet
    ];
    services.open-webui = lib.mkIf config.ai-module.openWebui.enable {
      enable = true;
      package = pkgs.open-webui;
      host = "0.0.0.0";
      openFirewall = true;
      stateDir = "/mnt/share/open-webui/stateDir";
    };

    systemd.services.open-webui.serviceConfig = lib.mkIf config.ai-module.openWebui.enable {
      ReadWritePaths = [ "${config.services.open-webui.stateDir}" ];
    };

    services.ollama = lib.mkIf config.ai-module.ollama.enable {
      enable = true;
      package = pkgs.ollama-rocm;
      user = "ollama";
      models = "/mnt/share/ollama/models";
      home = "/mnt/share/ollama/home";
      acceleration = "rocm";
      # rocmOverrideGfx = "11.0.0"; # 7900xt (gpu-family)
      loadModels = [
        "mistral"
      ];
    };

    # match uid on systems
    users.users.ollama = lib.mkIf config.ai-module.ollama.enable {
      uid = 995;
    };

    systemd.services.ollama = lib.mkIf config.ai-module.ollama.enable {
      serviceConfig = {
        ExecStartPre = "/run/current-system/sw/bin/sleep 10"; # add delay, did not find solution for race problem
        ReadWritePaths = [
          "${config.services.ollama.models}"
          "${config.services.ollama.home}"
        ];
      };
    };

    systemd.services.ollama-model-loader.serviceConfig = lib.mkIf config.ai-module.ollama.enable {
      ReadWritePaths = [
        "${config.services.ollama.models}"
        "${config.services.ollama.home}"
      ];
    };

    # users.groups.ollama.members = [ "${variables.user}" ];
  };
}
