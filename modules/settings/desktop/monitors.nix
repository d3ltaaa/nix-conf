{
  lib,
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [ nwg-displays ];

  home-manager.users.${config.settings.users.primary} =
    let
      nixos-config = config;
    in
    {
      config,
      lib,
      inputs,
      ...
    }:
    {
      home.activation = {
        touchConfigFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ ! -f "$HOME/.config/hypr/monitors.conf" ]; then
            touch $HOME/.config/hypr/monitors.conf
          fi
          if [ ! -f "$HOME/.config/hypr/workspaces.conf" ]; then
            touch $HOME/.config/hypr/workspaces.conf
          fi
        '';
      };
    };
}
