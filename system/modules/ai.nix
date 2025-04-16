{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ai-packages.enable = lib.mkEnableOption "Enable Ai packages";
  };
  config = lib.mkIf config.ai-packages.enable {
    services.open-webui = {
      enable = true;
      # port = 8080;
      package = pkgs.open-webui;
    };
    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      acceleration = "rocm";
      user = "ollama";
      group = "ollama";
      # models = "/home/falk/OllamaModels";
      # rocmOverrideGfx = "10.3.1";
      loadModels = [
        "gemma3:27b"
        "mistral"
      ];
    };
    users.groups.ollama.members = [ "falk" ];
  };
}
