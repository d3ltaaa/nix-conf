{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    truenas-module.enable = lib.mkEnableOption "Enables truenas module";
  };

  config = lib.mkIf config.truenas-module.enable {
    # For mount.cifs, required unless domain name resolution is not needed.
    environment.systemPackages = [
      pkgs.cifs-utils
      # pkgs.nfs-utils
    ];
    fileSystems."/mnt/share" = {
      device = "//192.168.2.12/falk";
      fsType = "cifs";
      options =
        let
          # this line prevents hanging on network split
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

        in
        [ "${automount_opts},credentials=/etc/samba/smb-secrets,uid=1000,gid=100" ];
    };
    # fileSystems."/mnt/test" = {
    #   device = "192.168.2.12:/mnt/storage/test";
    #   fsType = "nfs";
    # };
    # # optional, but ensures rpc-statsd is running for on demand mounting
    # boot.supportedFilesystems = [ "nfs" ];
  };
}
