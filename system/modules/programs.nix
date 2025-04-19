{ lib, config, ... }:
{
  imports = [
    ./submodules/programs/git.nix
  ];
  options = {
    programs-module.enable = lib.mkEnableOption "Enables Programs module";
  };
  config = lib.mkIf config.programs-module.enable {
    programs = {
      hyprland.enable = true;
      hyprlock.enable = true;
      hyprland.xwayland.enable = true;
      zsh.enable = true;
      thunar.enable = true;
      dconf.enable = true;
    };
  };
}
