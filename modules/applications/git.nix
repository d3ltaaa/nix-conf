{
  lib,
  config,
  pkgs,
  variables,
  ...
}:
{
  options = {
    applications.configuration.git = {
      enable = lib.mkEnableOption "Enables git module";
      username = lib.mkOption {
        type = lib.types.str;
        default = "d3ltaaa";
      };
    };
  };

  config = lib.mkIf config.applications.configuration.git.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "manager";
      config.credential."https://github.com".username = config.applications.configuration.git.username;
      config.credential.credentialstore = "cache";
    };
  };
}
