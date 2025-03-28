{ config, pkgs, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  rofi-theme = {
    "*" = {
      base = mkLiteral "#1e1e2e";
      base-alt = mkLiteral "#303446";
      fg = mkLiteral "#ffffff";
      tertiary = mkLiteral "@base-alt";
      background-color = mkLiteral "@base";
      rborder = mkLiteral "10px";
      sborder = mkLiteral "4px";
      cborder = mkLiteral "white";
      dpadding = mkLiteral "10px";
      dspacing = mkLiteral "10px";
    };

    window = {
      transparency = mkLiteral ''"real"'';
      width = 600;
      height = 600;
      border-radius = mkLiteral "@rborder";
      border = mkLiteral "@sborder";
      padding = 0;
      background-color = mkLiteral "@base";
      children = [ "mainbox" ];
      border-color = mkLiteral "white";
    };

    mainbox = {
      background-color = mkLiteral "@base";
      padding = mkLiteral "@dpadding";
      spacing = mkLiteral "@dspacing";
      orientation = mkLiteral "vertical";
      children = [
        "inputbar"
        "listview"
      ];
    };

    message = {
      background-color = mkLiteral "@tertiary";
      text-color = mkLiteral "@fg";
    };

    textbox = {
      background-color = mkLiteral "@tertiary";
      text-color = mkLiteral "@fg";
      font = mkLiteral ''"InconsolataGo Nerd Font Bold 11"'';
      horizontal-align = mkLiteral "0.50";
    };

    inputbar = {
      background-color = mkLiteral "transparent";
      border = mkLiteral "@sborder";
      border-color = mkLiteral "@cborder";
      border-radius = mkLiteral "@rborder";
      children = [
        "prompt"
        "entry"
      ];
    };

    prompt = {
      enabled = true;
      padding = mkLiteral "15 5 15 15";
      text-color = mkLiteral "@fg";
      background-color = mkLiteral "@base-alt";
      horizontal-align = mkLiteral "0.50";
      vertical-align = mkLiteral "0.50";
    };

    entry = {
      background-color = mkLiteral "@base-alt";
      padding = mkLiteral "15 0 15 0";
      text-color = mkLiteral "@fg";
      horizontal-align = mkLiteral "0.45"; # // center entry with 0.5
      vertical-align = mkLiteral "0.50";
      placeholder-color = mkLiteral "@fg";
      blink = false;
      placeholder = mkLiteral ''""'';
    };

    listview = {
      # 0.5
      background-color = mkLiteral "@base";
      columns = 1;
      scrollbar = false;
      lines = 8;
      # border-radius = 0 0 24 24;
      border-color = mkLiteral "transparent";
      spacing = mkLiteral "@dspacing";
    };

    element = {
      padding = mkLiteral "@dpadding";
      orientation = mkLiteral "horizontal";
      text-color = mkLiteral "@fg";
      position = mkLiteral "east";
      vertical-align = 0;
      horizontal-align = 0;
      background-color = mkLiteral "@base";
    };

    element-icon = {
      size = mkLiteral "3ch";
      align = mkLiteral "center";
      vertical-align = 0;
      yoffset = 50;
    };

    element-text = {
      vertical-align = mkLiteral "0.5";
    };

    "#element normal.normal" = {
      text-color = mkLiteral "@fg";
      background-color = mkLiteral "@base";
    };
    "#element normal.urgent" = {
      background-color = mkLiteral "@base";
    };
    "#element normal.active" = {
      background-color = mkLiteral "@base";
    };

    "#element selected.normal" = {
      text-color = mkLiteral "@fg";
      background-color = mkLiteral "@tertiary";
      border = mkLiteral "@sborder";
      border-color = mkLiteral "@cborder";
      border-radius = mkLiteral "@rborder";
    };
    "#element selected.urgent" = {
      background-color = mkLiteral "@base";
      border = mkLiteral "@sborder";
      border-color = mkLiteral "@cborder";
      border-radius = mkLiteral "@rborder";
    };
    "#element selected.active" = {
      background-color = mkLiteral "@base";
      border = mkLiteral "@sborder";
      border-color = mkLiteral "@cborder";
      border-radius = mkLiteral "@rborder";
    };

    "#element alternate.normal" = {
      text-color = mkLiteral "@fg";
      background-color = mkLiteral "@base";
    };
    "#element alternate.urgent" = {
      background-color = mkLiteral "@base";
    };
    "#element alternate.active" = {
      background-color = mkLiteral "@base";
    };
  };
in
{
  programs.rofi = {
    enable = true;
    theme = rofi-theme;
    package = pkgs.rofi-wayland;
    extraConfig = {
      kb-row-up = "Up,Alt+k,Shift+Tab,Shift+ISO_Left_Tab";
      kb-row-down = "Down,Alt+j";
      kb-accept-entry = "Return";
      terminal = "kitty";
      kb-remove-to-eol = "Alt+Shift+e";
      kb-mode-next = "Shift+Right,Alt+Tab,Alt+o";
      kb-mode-complete = "";
      kb-mode-previous = "Shift+Left,Alt+Shift+Tab,Alt+i";
      kb-remove-char-back = "BackSpace";
      kb-clear-line = "";
      kb-remove-word-back = "Alt+w";
      kb-cancel = "Escape,MouseSecondary";
      hover-select = true;
      me-select-entry = "";
      me-accept-entry = "MousePrimary";

      display-run = "";
      display-drun = "";
      display-window = "";
      drun-display-format = "{icon} {name}";
      modi = "window,run,drun";
      show-icons = true;
      # // font = "Meslo Nerd Font 12";
    };
  };
}
