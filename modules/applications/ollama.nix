{
  lib,
  config,
  nixpkgs-stable,
  pkgs,
  ...
}:
{
  options = {
    applications.configuration.ollama-server = {
      enable = lib.mkEnableOption "Enables Ollama module";
      dualSetup = lib.mkEnableOption "Is ollama running on two systems on the same pc?";
      modelDir = lib.mkOption {
        type = lib.types.str;
        default = "/mnt/share/ollama/models";
      };
      homeDir = lib.mkOption {
        type = lib.types.str;
        default = "/mnt/share/ollama/home";
      };
    };
  };
  config = lib.mkIf config.applications.configuration.ollama-server.enable {
    services.ollama = {
      enable = true;
      openFirewall = lib.mkIf config.applications.configuration.ollama-server.dualSetup true;
      host = lib.mkIf config.applications.configuration.ollama-server.dualSetup "0.0.0.0";
      user = "ollama";
      models = config.applications.configuration.ollama-server.modelDir;
      home = config.applications.configuration.ollama-server.homeDir;
      loadModels = [
      ];

      # only on amd-gpu
      package = lib.mkIf config.hardware.amdGpu.enable nixpkgs-stable.ollama-rocm;
      acceleration = lib.mkIf config.hardware.amdGpu.enable "rocm";
      # rocmOverrideGfx = "11.0.0"; # 7900xt (gpu-family)
    };

    # match uid on systems
    users.users.ollama = lib.mkIf config.applications.configuration.ollama-server.dualSetup {
      uid = 995;
    };

    systemd.services.ollama = {
      serviceConfig = {
        ExecStartPre = "/run/current-system/sw/bin/sleep 10"; # add delay, did not find solution for race problem
        ReadWritePaths = lib.mkIf config.applications.configuration.ollama-server.dualSetup [
          "${config.services.ollama.models}"
          "${config.services.ollama.home}"
        ];
      };
    };

    systemd.services.ollama-model-loader.serviceConfig = {
      ReadWritePaths = lib.mkIf config.applications.configuration.ollama-server.dualSetup [
        "${config.services.ollama.models}"
        "${config.services.ollama.home}"
      ];
    };
  };
}
