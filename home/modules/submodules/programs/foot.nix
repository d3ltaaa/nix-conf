{ lib, config, ... }:
{
  options = {
    foot-module.enable = lib.mkEnableOption "Enables Foot module";
  };

  config = lib.mkIf config.foot-module.enable {
    programs.foot.enable = true;
    programs.foot.settings = {
      main = {
        term = "xterm-256color";
        font = "UbuntuMonoNerdFont:size=12";
        font-bold = "UbuntuMonoNerdFont:size=12";
        font-italic = "UbuntuMonoNerdFont:size=12";
        font-bold-italic = "UbuntuMonoNerdFont:size=12";
        pad = "2x2"; # 5x5
      };
      cursor = {
        color = "${config.colorScheme.palette.base01} ${config.colorScheme.palette.base0F}";
      };
      colors = {
        alpha = "0.8";

        foreground = "${config.colorScheme.palette.base05}";
        background = "${config.colorScheme.palette.base02}";

        regular0 = "${config.colorScheme.palette.base04}";
        regular1 = "${config.colorScheme.palette.base08}";
        regular2 = "${config.colorScheme.palette.base0B}";
        regular3 = "${config.colorScheme.palette.base0A}";
        regular4 = "${config.colorScheme.palette.base0D}";
        regular5 = "${config.colorScheme.palette.base0E}";
        regular6 = "${config.colorScheme.palette.base0C}";
        regular7 = "${config.colorScheme.palette.base05}";

        bright0 = "${config.colorScheme.palette.base04}";
        bright1 = "${config.colorScheme.palette.base08}";
        bright2 = "${config.colorScheme.palette.base0B}";
        bright3 = "${config.colorScheme.palette.base0A}";
        bright4 = "${config.colorScheme.palette.base0D}";
        bright5 = "${config.colorScheme.palette.base0E}";
        bright6 = "${config.colorScheme.palette.base0C}";
        bright7 = "${config.colorScheme.palette.base05}";

        "16" = "${config.colorScheme.palette.base09}";
        "17" = "${config.colorScheme.palette.base0F}";

        selection-foreground = "${config.colorScheme.palette.base05}";
        selection-background = "${config.colorScheme.palette.base02}";

        search-box-no-match = "${config.colorScheme.palette.base01} ${config.colorScheme.palette.base08}";
        search-box-match = "${config.colorScheme.palette.base05} ${config.colorScheme.palette.base03}";

        jump-labels = "${config.colorScheme.palette.base01} ${config.colorScheme.palette.base09}";
        urls = "${config.colorScheme.palette.base0D}";
      };
    };
  };
}
