{
  lib,
  config,
  pkgs,
  variables,
  ...
}:
let
  serverAddress = lib.strings.trim (builtins.readFile "/home/${variables.user}/.server_address");
in
{
  options = {
    caddy-module.enable = lib.mkEnableOption "Enable caddy module";
  };
  config = lib.mkIf config.caddy-module.enable {
    networking.firewall.allowedTCPPorts = [ 8006 ]; # For Proxmox Web UI
    services.caddy = {
      enable = true;

      virtualHosts."${serverAddress}" = {
        extraConfig = ''
          handle_path /proxmox/* {
            reverse_proxy https://192.168.2.10:8006 {
              transport http {
                tls_insecure_skip_verify
              }
            }
          }
        '';
      };
    };
  };
}
