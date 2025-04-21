{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  options = {
    theme-module.enable = lib.mkEnableOption "Enables Theme module";
  };
  config = lib.mkIf config.theme-module.enable {
    colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
    # colorScheme = {
    #   name = "catppuccin-macchiato";
    #   palette = {
    #     base00 = "1e2030"; # #1e2030 default background
    #     base01 = "24273a"; # #24273a lighter background (status bars, line numbers, folding marks)
    #     base02 = "363a4f"; # #363a4f selection background
    #     base03 = "494d64"; # #494d64 comments, invisibles, line highlighting
    #     base04 = "5b6078"; # #5b6078 dark foreground
    #     base05 = "cad3f5"; # #cad3f5 default foreground, delimiters, operators
    #     base06 = "ffffff"; # #ffffff light foreground
    #     base07 = "b7bdf8"; # #b7bdf8 light background
    #     base08 = "ed8796"; # #ed8796 variables, xml tags, markup link text
    #     base09 = "f5a97f"; # #f5a97f integers, boolean, constants
    #     base0A = "eed49f"; # #eed49f classes, markup bold, search text background
    #     base0B = "a6da95"; # #a6da95 strings, inherited class, markup code
    #     base0C = "8bd5ca"; # #8bd5ca support, regular expressions, escape characters
    #     base0D = "8aadf4"; # #8aadf4 functions, methods, headings
    #     base0E = "c6a0f6"; # #c6a0f6 keywords, storage, selector
    #     base0F = "f0c6c6"; # #f0c6c6 deprecated
    #   };
    # };

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
