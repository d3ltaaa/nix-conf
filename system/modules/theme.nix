{ lib, config, ... }:
{
  options = {
    theme-module.enable = lib.mkEnableOption "Enables Theme module";
  };
  config = lib.mkIf config.theme-module.enable {
    catppuccin = {
      enable = true;
      flavor = "frappe";
      grub.enable = false;
    };
  };
}
