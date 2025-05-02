{ lib, config, ... }:
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
        thunar.enable = true;
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
