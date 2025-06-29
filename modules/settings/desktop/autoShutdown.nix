{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    settings.desktop.autoShutdown.enable = lib.mkEnableOption "Enables autoShutdown module";
    settings.desktop.autoShutdown.watchPort = lib.mkOption {
      type = lib.types.str;
      default = "11434";
    };
    settings.desktop.autoShutdown.shutdownTime = lib.mkOption {
      type = lib.types.str;
      default = "1800";
    };
  };
  config = lib.mkIf config.settings.desktop.autoShutdown.enable {
    systemd.services.init-activity-timestamp = {
      description = "Initialize server activity timestamp on boot";
      wantedBy = [ "multi-user.target" ]; # Run at boot
      before = [ "inactivity-shutdown.service" ]; # Ensure it's run before the shutdown check
      path = with pkgs; [ coreutils ];
      script = ''
        mkdir -p /var/lib/server-activity
        date +%s > /var/lib/server-activity/last-active
        echo "Activity timestamp initialized at boot."
      '';
      serviceConfig.Type = "oneshot";
    };

    systemd.services.update-activity = {
      description = "Monitors server activity (Port: ${config.settings.desktop.autoShutdown.watchPort})";
      path = with pkgs; [
        procps
        iproute2
        coreutils
      ];
      script = ''
        mkdir -p /var/lib/server-activity
        # initialize file
        if [ ! -f "/var/lib/server-activity/last-active" ]; then
          date +%s > /var/lib/server-activity/last-active
        fi

        # check for active TCP connections to Open-webui
        if ss -tnp | grep -E ':(${config.settings.desktop.autoShutdown.watchPort})' | grep ESTAB; then 
          date +%s > /var/lib/server-activity/last-active
          echo "Activity detected, updating timestamp";
        else
          echo "No Activity detected"
        fi
      '';
      serviceConfig.Type = "oneshot";
    };
    systemd.timers.update-activity = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5s";
        OnUnitActiveSec = "2s";
        AccuracySec = "1s";
      };
    };

    systemd.services.inactivity-shutdown = {
      description = "Shutdown server after ${config.settings.desktop.autoShutdown.shutdownTime}s";
      path = with pkgs; [ coreutils ];
      script = ''
        heartbeat="/var/lib/server-activity/last-active"
        countdown_file="/var/lib/server-activity/shutdown-in"

        # Exit if the heartbeat file doesn't exist yet
        if [ ! -f "$heartbeat" ]; then
          echo "No heartbeat file; skipping shutdown."
          exit 0
        fi

        last_active=$(cat "$heartbeat")
        now=$(date +%s)
        diff=$((now - last_active))
        remaining=$((${config.settings.desktop.autoShutdown.shutdownTime} - diff))

        if [ "$remaining" -le 0 ]; then
          echo "0" > "$countdown_file"
          echo "Inactivity timeout exceeded, shutting down..."
          shutdown +1 "Shutting down due to 30 minutes of inactivity."
        else
          echo "$remaining" > "$countdown_file"
          echo "Recent activity ($diff seconds ago); $remaining seconds left before shutdown."
        fi

      '';
      serviceConfig.Type = "oneshot";
    };
    systemd.timers.inactivity-shutdown = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "10min";
        OnUnitActiveSec = "5min";
      };
    };
  };
}
