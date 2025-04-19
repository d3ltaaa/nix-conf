{ lib, config, ... }:
{
  options = {
    environment-module.enable = lib.mkEnableOption "Enables Environment module";
  };
  config = lib.mkIf config.environment-module.enable {
    environment.variables = {
      EDITOR = "nvim";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      WLR_RENDERER_ALLOW_SOFTWARE = 1;
    };
  };
}
