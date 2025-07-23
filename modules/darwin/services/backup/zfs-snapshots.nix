{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.zfs-snapshots;

  # Create snapshot script for a dataset (Darwin version)
  mkSnapshotScript = dataset: settings: let
    datasetName = replaceStrings ["/"] ["-"] dataset;
    script = pkgs.writeShellScript "zfs-snapshot-${datasetName}" ''
      set -euo pipefail

      DATASET="${dataset}"
      TYPE="$1"  # daily, weekly, monthly

      # Ensure ZFS is available on macOS
      export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

      # Check if zfs command is available
      if ! command -v zfs >/dev/null 2>&1; then
        echo "Error: ZFS command not found. Please install OpenZFS for macOS."
        exit 1
      fi

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

        # Update metrics for monitoring (Darwin version)
        mkdir -p /opt/homebrew/var/lib/zfs-snapshots 2>/dev/null || mkdir -p /usr/local/var/lib/zfs-snapshots 2>/dev/null || true
        METRICS_DIR="/opt/homebrew/var/lib/zfs-snapshots"
        [[ ! -d "$METRICS_DIR" ]] && METRICS_DIR="/usr/local/var/lib/zfs-snapshots"
        echo "zfs_snapshot_created{dataset=\"$DATASET\",type=\"$TYPE\"} $(date +%s)" >> "$METRICS_DIR/metrics.prom" 2>/dev/null || true
      else
        echo "Failed to create snapshot: $SNAPSHOT_NAME"
        METRICS_DIR="/opt/homebrew/var/lib/zfs-snapshots"
        [[ ! -d "$METRICS_DIR" ]] && METRICS_DIR="/usr/local/var/lib/zfs-snapshots"
        echo "zfs_snapshot_failed{dataset=\"$DATASET\",type=\"$TYPE\"} $(date +%s)" >> "$METRICS_DIR/metrics.prom" 2>/dev/null || true
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
            METRICS_DIR="/opt/homebrew/var/lib/zfs-snapshots"
            [[ ! -d "$METRICS_DIR" ]] && METRICS_DIR="/usr/local/var/lib/zfs-snapshots"
            echo "zfs_snapshot_cleanup_failed{dataset=\"$DATASET\",type=\"$TYPE\"} $(date +%s)" >> "$METRICS_DIR/metrics.prom" 2>/dev/null || true
          fi
        done

      # Update last successful snapshot time
      METRICS_DIR="/opt/homebrew/var/lib/zfs-snapshots"
      [[ ! -d "$METRICS_DIR" ]] && METRICS_DIR="/usr/local/var/lib/zfs-snapshots"
      echo "zfs_snapshot_last_success{dataset=\"$DATASET\",type=\"$TYPE\"} $(date +%s)" >> "$METRICS_DIR/metrics.prom" 2>/dev/null || true
    '';
  in
    script;

  # Create launchd plist for Darwin
  mkLaunchDaemon = dataset: settings: type: let
    datasetName = replaceStrings ["/"] ["-"] dataset;
    serviceName = "org.nixos.zfs-snapshot-${datasetName}-${type}";
    schedule =
      settings.schedule.${
        type
      } or (
        if type == "daily"
        then {
          Hour = 2;
          Minute = 0;
        }
        else if type == "weekly"
        then {
          Weekday = 0;
          Hour = 3;
          Minute = 0;
        } # Sunday
        else if type == "monthly"
        then {
          Day = 1;
          Hour = 4;
          Minute = 0;
        }
        else {
          Hour = 2;
          Minute = 0;
        }
      );

    # Convert schedule string to launchd format if it's a string
    scheduleConfig =
      if builtins.isString settings.schedule.${type} or null
      then
        # Parse simple formats like "02:00", "Sun 03:00", "1 04:00"
        (
          if type == "daily"
          then {
            Hour = 2;
            Minute = 0;
          }
          else if type == "weekly"
          then {
            Weekday = 0;
            Hour = 3;
            Minute = 0;
          }
          else {
            Day = 1;
            Hour = 4;
            Minute = 0;
          }
        )
      else schedule;
  in {
    name = serviceName;
    value = {
      serviceConfig = {
        Label = serviceName;
        ProgramArguments = [
          "${mkSnapshotScript dataset settings}"
          type
        ];
        StartCalendarInterval = [scheduleConfig];
        StandardOutPath = "/opt/homebrew/var/log/zfs-snapshots-${datasetName}-${type}.log";
        StandardErrorPath = "/opt/homebrew/var/log/zfs-snapshots-${datasetName}-${type}.log";
      };
    };
  };

  # Generate all launchd services for configured datasets
  allLaunchDaemons = lib.listToAttrs (
    lib.flatten (
      lib.mapAttrsToList (
        dataset: settings:
          lib.map (type: mkLaunchDaemon dataset settings type)
          (lib.filter (type: settings.${type} > 0) ["daily" "weekly" "monthly"])
      )
      cfg.datasets
    )
  );
in {
  options.services.zfs-snapshots = {
    enable = mkEnableOption "ZFS automatic snapshots (Darwin)";

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
                  description = "Daily snapshot schedule";
                };

                weekly = mkOption {
                  type = types.str;
                  default = "Sun 03:00";
                  description = "Weekly snapshot schedule";
                };

                monthly = mkOption {
                  type = types.str;
                  default = "1 04:00";
                  description = "Monthly snapshot schedule";
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
  };

  config = mkIf cfg.enable {
    # Create launchd services for snapshots
    launchd.daemons = allLaunchDaemons;

    # Ensure log and metrics directories exist
    system.activationScripts.zfs-snapshots-dirs = {
      text = ''
        # Create directories for ZFS snapshots
        mkdir -p /opt/homebrew/var/log 2>/dev/null || mkdir -p /usr/local/var/log
        mkdir -p /opt/homebrew/var/lib/zfs-snapshots 2>/dev/null || mkdir -p /usr/local/var/lib/zfs-snapshots

        # Set permissions
        chmod 755 /opt/homebrew/var/log 2>/dev/null || chmod 755 /usr/local/var/log 2>/dev/null || true
        chmod 755 /opt/homebrew/var/lib/zfs-snapshots 2>/dev/null || chmod 755 /usr/local/var/lib/zfs-snapshots 2>/dev/null || true
      '';
    };

    # Add informational message about ZFS on macOS
    system.activationScripts.zfs-snapshots-info = {
      text = ''
        echo "ZFS Snapshots configured for Darwin"
        echo "Ensure OpenZFS for macOS is installed: https://openzfsonosx.org/"
        echo "Datasets configured: ${lib.concatStringsSep ", " (lib.attrNames cfg.datasets)}"
      '';
    };
  };
}
