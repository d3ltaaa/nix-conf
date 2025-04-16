{ ... }:
{
  catppuccin = {
    enable = true;
    flavor = "frappe";
    dunst.enable = false;
    hyprlock.enable = false;
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
}
