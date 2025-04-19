{
  lib,
  config,
  pkgs,
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
      })
      (lib.mkIf (config.brightness-module.monitorType == "external") {
        environment.systemPackages = with pkgs; [ ddcutil ];
      })
    ]
  );
}
