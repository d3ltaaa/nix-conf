{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    settings.security.monitoring = {
      enable = lib.mkEnableOption "Enables the monitoring-script for systemd services";
      OnBootSec = lib.mkOption {
        type = lib.types.str;
        default = "5min";
      };
      OnUnitActiveSec = lib.mkOption {
        type = lib.types.str;
        default = "1h";
      };
      services = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              notify = lib.mkOption {
                type = lib.types.str;
                description = "Email address or webhook URL to send notifications to";
                example = "alerts@example.com";
              };
              flag = lib.mkOption {
                type = lib.types.enum [
                  0
                  1
                ];
                description = "Notification type: 0 for email, 1 for webhook";
                example = 0;
              };
              service = lib.mkOption {
                type = lib.types.str;
                description = "Name of the systemd service to monitor";
                example = "nginx.service";
              };
              pattern = lib.mkOption {
                type = lib.types.str;
                description = "Regex pattern to search for in service logs";
                example = "error|warning|critical";
              };
              title = lib.mkOption {
                type = lib.types.str;
                description = "Title of the notification";
                example = "Service Alert";
              };
              timeframe = lib.mkOption {
                type = lib.types.str;
                description = "Time range for looking back in logs";
                example = "1 day ago";
              };
            };
          }
        );
        default = [ ];
      };
    };
  };
  config =
    let
      cfg = config.settings.security.monitoring;
      monitor-script = pkgs.writeScriptBin "monitor-systemd-script" ''
        #!/run/current-system/sw/bin/bash

        # Check if all required arguments are provided
        if [ $# -lt 6 ]; then
            echo "Usage: $0 <webhook/mail_address> <webhook_or_mail_flag> <systemd_service> <patterns> <title> <time_range>"
            echo "webhook_or_mail_flag: 1 for webhook, 0 for mail"
            echo "patterns: Search pattern for journalctl (use quotes if it contains spaces)"
            echo "time_range: Time range for logs (e.g., \"5 minutes ago\", \"2 hours ago\", \"1 day ago\")"
            exit 1
        fi

        # Assign input parameters
        TARGET_ADDRESS="$1"
        WEBHOOK_FLAG="$2"
        SERVICE_NAME="$3"
        PATTERNS="$4"
        TITLE="$5"
        TIME_RANGE="$6"

        # Validate webhook/mail flag
        if [[ "$WEBHOOK_FLAG" != "0" && "$WEBHOOK_FLAG" != "1" ]]; then
            echo "Error: webhook_or_mail_flag must be 0 (mail) or 1 (webhook)"
            exit 1
        fi

        # Check if the systemd service exists
        if ! systemctl list-units --type=service | grep -q "$SERVICE_NAME"; then
            echo "Error: Systemd service '$SERVICE_NAME' not found"
            exit 1
        fi

        # Check for matching patterns in the service logs with the specified time range
        MATCHING_LOGS=$(journalctl -u "$SERVICE_NAME" --since "$TIME_RANGE" | grep -iE "$PATTERNS")

        # If there are matching logs, send notification
        if [ -n "$MATCHING_LOGS" ]; then
            # Prepare the message
            MESSAGE="Matching log entries from $SERVICE_NAME (since $TIME_RANGE):\n\n$MATCHING_LOGS"

            # Send notification based on the webhook flag
            if [ "$WEBHOOK_FLAG" -eq 1 ]; then
                # Send the webhook request
                curl -H "Title: $TITLE" -H "Priority: urgent" -d "$MATCHING_LOGS" $TARGET_ADDRESS &&
                echo "Notification sent via webhook to $TARGET_ADDRESS"
            else
                # Send via email using sendmail
                HOSTNAME=$(hostname)
                DATE=$(date +"%a, %d %b %Y %T %z")

                {
                    # echo "From: System Monitor <system@$HOSTNAME>"
                    echo "To: $TARGET_ADDRESS"
                    echo "Subject: $TITLE - Service Log Alert"
                    echo "Date: $DATE"
                    echo "MIME-Version: 1.0"
                    echo "Content-Type: text/plain; charset=utf-8"
                    echo ""
                    echo -e "$MESSAGE"
                } | sendmail $TARGET_ADDRESS

                echo "Notification sent via email to $TARGET_ADDRESS"
            fi
        else
            echo "No matching logs found for patterns: $PATTERNS since $TIME_RANGE"
        fi

        exit 0

      '';
      scriptPath = "${monitor-script}/bin/monitor-systemd-script";

    in
    lib.mkIf cfg.enable {
      systemd.services.monitor-systemd-service = {
        description = "Service for periodically running monitor-systemd-script";
        path = [
          pkgs.bash
          pkgs.curl
          pkgs.jq
          pkgs.mailutils
        ];

        serviceConfig = {
          Type = "oneshot";
          User = "root"; # Or specify another user
          ExecStart =
            let
              # Create an array of commands, one for each service to monitor
              commands = map (svc: ''
                ${scriptPath} "${svc.notify}" "${toString svc.flag}" "${svc.service}" "${svc.pattern}" "${svc.title}" "${svc.timeframe}"
              '') cfg.services;
            in
            # Join all commands with newlines to create a bash script
            "${pkgs.writeShellScript "monitor-services" ''
              ${builtins.concatStringsSep "\n" commands}
            ''}";
        };
      };

      systemd.timers.monitor-systemd-service = {
        description = "Timer for periodically running monitor-systemd-service";
        wantedBy = [ "timers.target" ];

        # Timer configuration
        timerConfig = {
          OnBootSec = config.settings.security.monitoring.OnBootSec;
          OnUnitActiveSec = config.settings.security.monitoring.OnUnitActiveSec;

          Unit = "monitor-systemd-service.service";
        };
      };

      # "Usage: $0 <webhook/mail_address> <webhook_or_mail_flag> <systemd_service> <patterns> <title> <time_range>"
      environment.systemPackages = [
        monitor-script
      ];
    };
}
