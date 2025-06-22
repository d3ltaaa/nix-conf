{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.brightness = {
      enable = lib.mkEnableOption "Enables brightness module";
      monitorType = lib.mkOption {
        type = lib.types.enum [
          "internal"
          "external"
        ];
        default = "internal";
      };
    };
  };
  config = lib.mkIf config.hardware.brightness.enable (
    lib.mkMerge [
      (lib.mkIf (config.hardware.brightness.monitorType == "internal") {
        environment.systemPackages = with pkgs; [ brillo ];
        environment.variables.MONITOR_TYPE = "internal";
      })
      (lib.mkIf (config.hardware.brightness.monitorType == "external") {
        environment.systemPackages = with pkgs; [
          ddcutil
        ];
        hardware.i2c.enable = true;
        environment.variables.MONITOR_TYPE = "external";
      })
    ]
  );
}
