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
        device = "//192.168.2.12/public";
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
      useDHCP = false;
      interfaces.ens18.ipv4.addresses = [
        {
          address = "192.168.2.12";
          prefixLength = 24;
        }
      ];
      defaultGateway = "192.168.2.1";
      nameservers = [
        "192.168.2.1"
      ]; # or your router's DNS

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

          public = {
            "path" = "/mnt/shared/public";
            "browseable" = "yes";
            "read only" = "no";
            "guest ok" = "yes";
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = "nixos";
            "force group" = "users";
          };
        };
      };

      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };

      networking.firewall.enable = true;
      networking.firewall.allowPing = true;

    })
  ];
}
