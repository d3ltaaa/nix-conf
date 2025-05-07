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
}
