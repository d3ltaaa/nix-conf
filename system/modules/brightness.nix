{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    brightness-module.enable = lib.mkEnableOption "Enables Brightness module";
    monitortype-option = lib.mkOption {
      type = lib.types.enum [
        "internal"
        "external"
      ];
      default = "internal";
    };
  };
  config = lib.mkIf config.brightness-module.enable (
    lib.mkMerge [
      (lib.mkIf (config.monitortype-option == "internal") {
        environment.systemPackages = with pkgs; [ brillo ];
      })
      (lib.mkIf (config.monitortype-option == "external") {
        environment.systemPackages = with pkgs; [ ddcutil ];
      })
    ]
  );
}
