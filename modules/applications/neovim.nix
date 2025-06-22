{ lib, config, ... }:
{
  options = {
    applications.configuration.neovim.enable = lib.mkEnableOption "Enables neovim module";
  };
  config = lib.mkIf config.applications.configuration.neovim.enable {
    # Home Manager as NixOS module
    home-manager.users.${config.settings.users.primary} =
      { config, ... }:
      {
        imports = [
          ./neovim/default.nix
        ];
      };
  };
}
