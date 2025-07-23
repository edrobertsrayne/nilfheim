{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.zfs-snapshots;

  # Create snapshot script for a dataset
  mkSnapshotScript = dataset: settings: let
    datasetName = replaceStrings ["/"] ["-"] dataset;
    script = pkgs.writeShellScript "zfs-snapshot-${datasetName}" ''
      set -euo pipefail

      DATASET="${dataset}"
      TYPE="$1"  # daily, weekly, monthly

      # Create timestamp
      case "$TYPE" in
        daily)
          TIMESTAMP=$(date '+%Y-%m-%d_%H-%M')
          KEEP=${toString settings.daily}
          ;;
        weekly)
          TIMESTAMP=$(date '+%Y-W%U')
          KEEP=${toString settings.weekly}
          ;;
        monthly)
          TIMESTAMP=$(date '+%Y-%m')
          KEEP=${toString settings.monthly}
          ;;
        *)
          echo "Error: Invalid snapshot type: $TYPE"
          exit 1
          ;;
      esac

      SNAPSHOT_NAME="$DATASET@auto-$TYPE-$TIMESTAMP"

      # Check if dataset exists
      if ! zfs list "$DATASET" >/dev/null 2>&1; then
        echo "Error: Dataset $DATASET does not exist"
        exit 1
      fi

      # Create snapshot
      echo "Creating snapshot: $SNAPSHOT_NAME"
      if zfs snapshot "$SNAPSHOT_NAME"; then
        echo "Successfully created snapshot: $SNAPSHOT_NAME"

        # Update metrics for monitoring
        echo "zfs_snapshot_created{dataset=\"$DATASET\",type=\"$TYPE\"} $(date +%s)" >> /var/lib/zfs-snapshots/metrics.prom || true
      else
        echo "Failed to create snapshot: $SNAPSHOT_NAME"
        echo "zfs_snapshot_failed{dataset=\"$DATASET\",type=\"$TYPE\"} $(date +%s)" >> /var/lib/zfs-snapshots/metrics.prom || true
        exit 1
      fi

      # Clean up old snapshots
      echo "Cleaning up old $TYPE snapshots for $DATASET (keeping $KEEP)"
      zfs list -H -t snapshot -o name -s creation | \
        grep "^$DATASET@auto-$TYPE-" | \
        head -n -$KEEP | \
        while read snapshot; do
          echo "Removing old snapshot: $snapshot"
          if zfs destroy "$snapshot"; then
            echo "Successfully removed: $snapshot"
          else
            echo "Failed to remove: $snapshot"
            echo "zfs_snapshot_cleanup_failed{dataset=\"$DATASET\",type=\"$TYPE\"} $(date +%s)" >> /var/lib/zfs-snapshots/metrics.prom || true
          fi
        done

      # Update last successful snapshot time
      echo "zfs_snapshot_last_success{dataset=\"$DATASET\",type=\"$TYPE\"} $(date +%s)" >> /var/lib/zfs-snapshots/metrics.prom || true
    '';
  in
    script;

  # Create systemd service for a dataset and snapshot type
  mkSnapshotService = dataset: settings: type: let
    datasetName = replaceStrings ["/"] ["-"] dataset;
    serviceName = "zfs-snapshot-${datasetName}-${type}";
  in {
    name = serviceName;
    value = {
      description = "ZFS ${type} snapshot for ${dataset}";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${mkSnapshotScript dataset settings} ${type}";
        StandardOutput = "journal";
        StandardError = "journal";
      };
      # Ensure ZFS is available
      after = ["zfs.target"];
      wants = ["zfs.target"];
    };
  };

  # Create systemd timer for a dataset and snapshot type
  mkSnapshotTimer = dataset: settings: type: let
    datasetName = replaceStrings ["/"] ["-"] dataset;
    serviceName = "zfs-snapshot-${datasetName}-${type}";
    timerName = "${serviceName}.timer";
    schedule =
      settings.schedule.${
        type
      } or (
        if type == "daily"
        then "02:00"
        else if type == "weekly"
        then "Sun 03:00"
        else if type == "monthly"
        then "1 04:00"
        else "02:00"
      );
  in {
    name = timerName;
    value = {
      description = "Timer for ZFS ${type} snapshot of ${dataset}";
      timerConfig = {
        OnCalendar = schedule;
        Persistent = true;
        RandomizedDelaySec = "15min"; # Spread load
      };
      wantedBy = ["timers.target"];
    };
  };

  # Generate all services and timers for configured datasets
  allServices = lib.listToAttrs (
    lib.flatten (
      lib.mapAttrsToList (
        dataset: settings:
          lib.map (type: mkSnapshotService dataset settings type)
          (lib.filter (type: settings.${type} > 0) ["daily" "weekly" "monthly"])
      )
      cfg.datasets
    )
  );

  allTimers = lib.listToAttrs (
    lib.flatten (
      lib.mapAttrsToList (
        dataset: settings:
          lib.map (type: mkSnapshotTimer dataset settings type)
          (lib.filter (type: settings.${type} > 0) ["daily" "weekly" "monthly"])
      )
      cfg.datasets
    )
  );

  # Metrics collection script
  metricsCollectionScript = pkgs.writeShellScript "zfs-snapshots-metrics" ''
    set -euo pipefail

    METRICS_FILE="/var/lib/zfs-snapshots/metrics.prom"
    TEMP_FILE="/tmp/zfs-snapshots-metrics.tmp"

    # Create metrics directory
    mkdir -p /var/lib/zfs-snapshots

    # Clear old metrics and create new ones
    echo "# HELP zfs_snapshot_count Number of snapshots per dataset and type" > "$TEMP_FILE"
    echo "# TYPE zfs_snapshot_count gauge" >> "$TEMP_FILE"

    # Count existing snapshots
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (dataset: settings: ''
        for type in daily weekly monthly; do
          count=$(zfs list -H -t snapshot -o name | grep "^${dataset}@auto-$type-" | wc -l || echo 0)
          echo "zfs_snapshot_count{dataset=\"${dataset}\",type=\"$type\"} $count" >> "$TEMP_FILE"
        done
      '')
      cfg.datasets
    )}

    # Append any existing event metrics (preserving them)
    if [[ -f "$METRICS_FILE" ]]; then
      grep -E "^zfs_snapshot_(created|failed|cleanup_failed|last_success)" "$METRICS_FILE" >> "$TEMP_FILE" 2>/dev/null || true
    fi

    # Atomically update metrics file
    mv "$TEMP_FILE" "$METRICS_FILE"
    chmod 644 "$METRICS_FILE"
  '';
in {
  options.services.zfs-snapshots = {
    enable = mkEnableOption "ZFS automatic snapshots";

    datasets = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          daily = mkOption {
            type = types.int;
            default = 7;
            description = "Number of daily snapshots to keep (0 to disable)";
          };

          weekly = mkOption {
            type = types.int;
            default = 4;
            description = "Number of weekly snapshots to keep (0 to disable)";
          };

          monthly = mkOption {
            type = types.int;
            default = 3;
            description = "Number of monthly snapshots to keep (0 to disable)";
          };

          schedule = mkOption {
            type = types.submodule {
              options = {
                daily = mkOption {
                  type = types.str;
                  default = "02:00";
                  description = "Daily snapshot schedule (systemd calendar format)";
                };

                weekly = mkOption {
                  type = types.str;
                  default = "Sun 03:00";
                  description = "Weekly snapshot schedule (systemd calendar format)";
                };

                monthly = mkOption {
                  type = types.str;
                  default = "1 04:00";
                  description = "Monthly snapshot schedule (systemd calendar format)";
                };
              };
            };
            default = {};
            description = "Custom schedule overrides for snapshot types";
          };
        };
      });
      default = {};
      example = {
        "zroot/local/home" = {
          daily = 7;
          weekly = 4;
          monthly = 3;
        };
      };
      description = "ZFS datasets to snapshot with retention policies";
    };

    alerting = {
      enable = mkEnableOption "Prometheus alerting for ZFS snapshots";
    };
  };

  config = mkIf cfg.enable {
    # Ensure ZFS is supported
    boot.supportedFilesystems = ["zfs"];

    # Create snapshot services and timers
    systemd.services =
      allServices
      // {
        # Metrics collection service
        zfs-snapshots-metrics = {
          description = "Collect ZFS snapshots metrics";
          serviceConfig = {
            Type = "oneshot";
            User = "root";
            ExecStart = metricsCollectionScript;
          };
          after = ["zfs.target"];
          wants = ["zfs.target"];
        };
      };

    systemd.timers =
      allTimers
      // {
        # Metrics collection timer
        "zfs-snapshots-metrics.timer" = {
          description = "Timer for ZFS snapshots metrics collection";
          timerConfig = {
            OnCalendar = "*:0/5"; # Every 5 minutes
            Persistent = true;
          };
          wantedBy = ["timers.target"];
        };
      };

    # Create metrics directory with proper permissions
    systemd.tmpfiles.rules = [
      "d /var/lib/zfs-snapshots 0755 root root -"
      "f /var/lib/zfs-snapshots/metrics.prom 0644 root root -"
    ];

    # Note: Alerting rules and node_exporter configuration should be added manually
    # to the host's prometheus configuration to avoid attribute conflicts.
    #
    # Add this to your prometheus configuration:
    # services.prometheus.ruleFiles = [ ./path/to/zfs-snapshots.yml ];
    # services.prometheus.exporters.node.extraFlags = [ "--collector.textfile.directory=/var/lib/zfs-snapshots" ];
  };
}
