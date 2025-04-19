{
  lib,
  config,
  variables,
  pkgs,
  ...
}:
{

  options = {
    user-module.enable = lib.mkEnableOption "Enables User module";
  };
  config = lib.mkIf config.user-module.enable {
    users.users.${variables.user} = {
      isNormalUser = true;
      description = "${variables.user}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
      ];
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
    };

    security.sudo.extraConfig = "Defaults        !sudoedit_checkdir";
  };
}
