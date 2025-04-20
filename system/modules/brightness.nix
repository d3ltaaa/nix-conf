{
  lib,
  config,
  pkgs,
  variables,
  ...
}:
{
  options = {
    brightness-module = {
      enable = lib.mkEnableOption "Enables Brightness module";
      monitorType = lib.mkOption {
        type = lib.types.enum [
          "internal"
          "external"
        ];
        default = "internal";
      };
    };
  };
  config = lib.mkIf config.brightness-module.enable (
    lib.mkMerge [
      (lib.mkIf (config.brightness-module.monitorType == "internal") {
        environment.systemPackages = with pkgs; [ brillo ];
        environment.variables.MONITOR_TYPE = "internal";
      })
      (lib.mkIf (config.brightness-module.monitorType == "external") {
        environment.systemPackages = with pkgs; [
          ddcutil
        ];
        hardware.i2c.enable = true;
        environment.variables.MONITOR_TYPE = "external";
      })
    ]
  );
}
