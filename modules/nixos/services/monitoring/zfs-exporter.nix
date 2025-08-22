{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.zfs-exporter;
  inherit (config) homelab;

  zfsMetricsScript = pkgs.writeShellScript "zfs-metrics" ''
    #!/bin/bash

    # ZFS Health Metrics for Prometheus
    # Outputs metrics in Prometheus text format for node_exporter textfile collector

    TEXTFILE_DIR="/var/lib/prometheus-node-exporter-text-files"
    METRICS_FILE="$TEXTFILE_DIR/zfs.prom"
    TEMP_FILE="$TEXTFILE_DIR/zfs.prom.tmp"

    # Ensure directory exists
    mkdir -p "$TEXTFILE_DIR"

    # Start metrics collection
    {
      echo "# HELP zfs_pool_state ZFS pool state (1=ONLINE, 0.5=DEGRADED, 0=FAULTED)"
      echo "# TYPE zfs_pool_state gauge"

      echo "# HELP zfs_pool_capacity_bytes ZFS pool capacity in bytes"
      echo "# TYPE zfs_pool_capacity_bytes gauge"

      echo "# HELP zfs_pool_used_bytes ZFS pool used space in bytes"
      echo "# TYPE zfs_pool_used_bytes gauge"

      echo "# HELP zfs_pool_available_bytes ZFS pool available space in bytes"
      echo "# TYPE zfs_pool_available_bytes gauge"

      echo "# HELP zfs_scrub_last_timestamp Last ZFS scrub completion timestamp"
      echo "# TYPE zfs_scrub_last_timestamp gauge"

      echo "# HELP zfs_scrub_errors ZFS scrub error count"
      echo "# TYPE zfs_scrub_errors gauge"

      # Get pool status and metrics
      ${pkgs.zfs}/bin/zpool list -H -o name,size,alloc,free,health | while IFS=$'\t' read -r pool size alloc free health; do
        # Convert pool state to numeric value
        case "$health" in
          "ONLINE") state=1 ;;
          "DEGRADED") state=0.5 ;;
          "FAULTED"|"OFFLINE"|"UNAVAIL") state=0 ;;
          *) state=0 ;;
        esac

        echo "zfs_pool_state{pool=\"$pool\"} $state"

        # Convert sizes to bytes (zpool outputs human readable by default in some cases)
        # Parse size values and convert to bytes
        size_bytes=$(echo "$size" | ${pkgs.gnused}/bin/sed 's/[KMGTPE]//g' | ${pkgs.gnugrep}/bin/grep -o '[0-9.]*' | head -1)
        alloc_bytes=$(echo "$alloc" | ${pkgs.gnused}/bin/sed 's/[KMGTPE]//g' | ${pkgs.gnugrep}/bin/grep -o '[0-9.]*' | head -1)
        free_bytes=$(echo "$free" | ${pkgs.gnused}/bin/sed 's/[KMGTPE]//g' | ${pkgs.gnugrep}/bin/grep -o '[0-9.]*' | head -1)

        # Get actual bytes values using zfs commands
        size_actual=$(${pkgs.zfs}/bin/zpool get -H -p -o value size "$pool" 2>/dev/null || echo "0")
        alloc_actual=$(${pkgs.zfs}/bin/zpool get -H -p -o value allocated "$pool" 2>/dev/null || echo "0")
        free_actual=$(${pkgs.zfs}/bin/zpool get -H -p -o value free "$pool" 2>/dev/null || echo "0")

        echo "zfs_pool_capacity_bytes{pool=\"$pool\"} $size_actual"
        echo "zfs_pool_used_bytes{pool=\"$pool\"} $alloc_actual"
        echo "zfs_pool_available_bytes{pool=\"$pool\"} $free_actual"
      done

      # Get scrub information
      ${pkgs.zfs}/bin/zpool status | ${pkgs.gawk}/bin/awk '
        /pool:/ { pool = $2 }
        /scan:/ {
          if (match($0, /scrub completed on (.+)/, arr)) {
            # Parse date and convert to timestamp
            cmd = "date -d \"" arr[1] "\" +%s 2>/dev/null || echo 0"
            cmd | getline timestamp
            close(cmd)
            print "zfs_scrub_last_timestamp{pool=\"" pool "\"} " timestamp
          }
          if (match($0, /([0-9]+) errors/, arr)) {
            print "zfs_scrub_errors{pool=\"" pool "\"} " arr[1]
          } else {
            print "zfs_scrub_errors{pool=\"" pool "\"} 0"
          }
        }
      '

      # Add dataset information
      echo "# HELP zfs_dataset_used_bytes ZFS dataset used space in bytes"
      echo "# TYPE zfs_dataset_used_bytes gauge"

      echo "# HELP zfs_dataset_available_bytes ZFS dataset available space in bytes"
      echo "# TYPE zfs_dataset_available_bytes gauge"

      ${pkgs.zfs}/bin/zfs list -H -p -o name,used,avail | while IFS=$'\t' read -r dataset used avail; do
        # Skip snapshots and use only main datasets
        if [[ ! "$dataset" =~ @ ]]; then
          echo "zfs_dataset_used_bytes{dataset=\"$dataset\"} $used"
          echo "zfs_dataset_available_bytes{dataset=\"$dataset\"} $avail"
        fi
      done

    } > "$TEMP_FILE"

    # Atomically move temp file to final location
    mv "$TEMP_FILE" "$METRICS_FILE"
  '';
in {
  options.services.zfs-exporter = {
    enable = mkEnableOption "ZFS health monitoring exporter";

    interval = mkOption {
      type = types.str;
      default = "1m";
      description = "Interval for ZFS metrics collection";
    };
  };

  config = mkIf cfg.enable {
    # Create textfile directory for node_exporter
    systemd.tmpfiles.rules = [
      "d /var/lib/prometheus-node-exporter-text-files 755 prometheus prometheus -"
    ];

    # ZFS metrics collection service
    systemd.services.zfs-exporter = {
      description = "ZFS Health Metrics Exporter";
      serviceConfig = {
        Type = "oneshot";
        User = "root"; # Need root to access ZFS commands
        ExecStart = "${zfsMetricsScript}";
      };
    };

    # Timer for regular metrics collection
    systemd.timers.zfs-exporter = {
      description = "ZFS Health Metrics Collection Timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "30s";
        OnUnitActiveSec = cfg.interval;
        Persistent = true;
      };
    };

    # Ensure ZFS tools are available
    environment.systemPackages = with pkgs; [
      zfs
    ];
  };
}
