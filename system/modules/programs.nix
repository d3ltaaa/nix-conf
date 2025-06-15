{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./submodules/programs/git.nix
  ];
  options = {
    programs-module = {
      enable = lib.mkEnableOption "Enables Programs module";
      programs = {
        hyprland = lib.mkEnableOption "Enables Hyprland programs";
        zsh = lib.mkEnableOption "Enables zsh";
        thunar = lib.mkEnableOption "Enables thunar";
        dconf = lib.mkEnableOption "Enables dconf";
        git = lib.mkEnableOption "Enables git";
      };
    };
  };

  config = lib.mkIf config.programs-module.enable {
    services = {
      gvfs.enable = true;
      tumbler.enable = true;
    };

    environment.systemPackages = with pkgs; [
      xdg-utils
      whitesur-icon-theme
    ];
    programs = lib.mkMerge [
      (lib.mkIf config.programs-module.programs.hyprland {
        hyprland.enable = true;
        hyprlock.enable = true;
        hyprland.xwayland.enable = true;
      })

      (lib.mkIf config.programs-module.programs.zsh {
        zsh.enable = true;
      })
      (lib.mkIf config.programs-module.programs.thunar {
        xfconf.enable = true;
        file-roller.enable = true;
        dconf.enable = true;
        thunar = {
          enable = true;
          plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-volman
          ];
        };
      })

      (lib.mkIf config.programs-module.programs.dconf {
        dconf.enable = true;
      })
      (lib.mkIf config.programs-module.programs.git {
        git.enable = true;
      })
    ];
  };
}
