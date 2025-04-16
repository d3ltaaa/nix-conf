{ config, lib, ... }:
{
  options = {
    git-module.enable = lib.mkEnableOption "Enables Git module";
  };
  config = lib.mkIf config.git-module.enable {
    programs.git = {
      enable = true;
      userName = "d3ltaaa";
      userEmail = "hil.falk@protonmail.com";
    };
  };
}
