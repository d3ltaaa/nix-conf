{
  lib,
  config,
  pkgs,
  variables,
  ...
}:

{

  config = lib.mkIf (config.networking.hostName == "WIREGUARD-SERVER") {
    environment.systemPackages = with pkgs; [
      wireguard-ui
    ];

    systemd.services.wireguard-ui = {
      enable = true;
      description = "WireGuard-UI Web Interface";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.wireguard-ui}/bin/wireguard-ui"; # path to wireguard-ui binary
        # Run as root (default), so no User/Group needed
        WorkingDirectory = "/etc/wireguard"; # or wherever configs live
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    systemd.services.wgui = {
      enable = true;
      description = "Restart WireGuard";
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl restart wg-quick@wg0.service";
      };
      wantedBy = [ "wgui.path" ]; # makes path unit trigger this service
    };

    systemd.paths.wgui = {
      enable = true;
      description = "Watch /etc/wireguard/wg0.conf for changes";
      pathConfig = {
        PathModified = "/etc/wireguard/wg0.conf";
      };
      wantedBy = [ "multi-user.target" ];
    };

    networking.firewall.allowedUDPPorts = [ 51821 ]; # Your wg0 port
  };
}
