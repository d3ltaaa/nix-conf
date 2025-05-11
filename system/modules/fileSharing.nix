{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    fileSharing-module = {
      enable = lib.mkEnableOption "Enables FileSharing module";
      type = lib.mkOption {
        type = lib.types.enum [
          "server"
          "client"
        ];
        default = "client";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.fileSharing-module.enable == true && config.fileSharing-module.type == "client") {
      # For mount.cifs, required unless domain name resolution is not needed.
      environment.systemPackages = [
        pkgs.cifs-utils
      ];
      fileSystems."/mnt/share" = {
        device = "//192.168.2.12/private";
        fsType = "cifs";
        options =
          let
            # this line prevents hanging on network split
            automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
          in
          [ "${automount_opts},credentials=/etc/samba/smb-secrets,uid=1000,gid=100" ];
      };
    })

    (lib.mkIf (config.fileSharing-module.enable == true && config.fileSharing-module.type == "server") {
      services.samba = {
        enable = true;
        securityType = "user";
        openFirewall = true;
        settings = {
          global = {
            "workgroup" = "WORKGROUP";
            "server string" = "nixos-smb";
            "netbios name" = "nixos-smb";
            "security" = "user";
            "hosts allow" = "192.168.2. 127.0.0.1 localhost";
            "hosts deny" = "0.0.0.0/0";
            "guest account" = "nobody";
            "map to guest" = "bad user";
          };

          private = {
            "path" = "/mnt/shared/private";
            "browseable" = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "valid user" = "falk";
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = "falk";
            "force group" = "users";
          };
        };
      };

      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    })
  ];
}
