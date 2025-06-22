{ lib, config, ... }:
{
  options = {
    applications.configuration.swappy.enable = lib.mkEnableOption "Enables swappy module";
  };

  config = lib.mkIf config.applications.configuration.swappy.enable {
    # Home Manager as NixOS module
    home-manager.users.${config.settings.users.primary} =
      { config, ... }:
      {
        xdg.configFile."swappy/config".text = ''
          [Default]
          save_dir=${config.xdg.userDirs.extraConfig.XDG_SCREENSHOT_DIR}
          save_filename_format=swappy-%Y%m%d-%H%M%S.png
          show_panel=false
          line_size=5
          text_size=20
          text_font=sans-serif
          paint_mode=brush
          early_exit=false
          fill_shape=false
          auto_save=false
          custom_color=rgba(193,125,17,1)
        '';
      };
  };
}
