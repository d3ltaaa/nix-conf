{ lib, config, ... }:
{
  options = {
    theme-module.enable = lib.mkEnableOption "Enables Theme module";
  };
  config = lib.mkIf config.theme-module.enable {
    catppuccin = {
      enable = true;
      flavor = "frappe";

      dunst.enable = false;
      hyprlock.enable = false;
      waybar.enable = false;

      gtk.enable = true;
      gtk.flavor = "latte";

    };
    gtk = {
      enable = true;
      # theme.name = "adw-gtk3";
      cursorTheme.name = "Bibata-Modern-Ice";
      iconTheme.name = "GruvboxPlus";
    };
    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
