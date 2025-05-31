{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    autoShutdown-module.enable = lib.mkEnableOption "Enables autoShutdown module";
    autoShutdown-module.watchPort = lib.mkOption {
      type = lib.types.str;
      default = "8080";
    };
  };
  config = lib.mkIf config.autoShutdown-module.enable {
    systemd.services.update-activity = {
      description = "Monitors server activity (Port: ${config.autoShutdown-module.watchPort})";
      path = with pkgs; [
        procps
        iproute2
        coreutils
      ];
      script = ''
        mkdir -p /var/lib/server-activity
        # check for active TCP connections to Open-webui
        if ss -tnp | grep -E ':(${config.autoShutdown-module.watchPort})' | grep ESTAB; then 
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
        OnBootSec = "1min";
        OnUnitActiveSec = "5min";
      };
    };
  };
}
