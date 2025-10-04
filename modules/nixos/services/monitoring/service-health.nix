{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.service-health;
  constants = import ../../../../lib/constants.nix;

  serviceHealthScript = pkgs.writeShellScript "service-health-check" ''
    #!/bin/bash

    # Service Health Checks for Prometheus
    # Monitors critical services and outputs metrics for node_exporter

    TEXTFILE_DIR="/var/lib/prometheus-node-exporter-text-files"
    METRICS_FILE="$TEXTFILE_DIR/service_health.prom"
    TEMP_FILE="$TEXTFILE_DIR/service_health.prom.tmp"

    # Ensure directory exists
    mkdir -p "$TEXTFILE_DIR"

    # Start metrics collection
    {
      echo "# HELP service_up Service availability (1=up, 0=down)"
      echo "# TYPE service_up gauge"

      echo "# HELP service_response_time Service HTTP response time in seconds"
      echo "# TYPE service_response_time gauge"

      # Function to check HTTP service health
      check_http_service() {
        local service="$1"
        local url="$2"
        local expected_status="$3"

        response_time=$(${pkgs.curl}/bin/curl -o /dev/null -s -w "%{time_total}" -m 10 --connect-timeout 5 "$url" 2>/dev/null || echo "0")
        status_code=$(${pkgs.curl}/bin/curl -o /dev/null -s -w "%{http_code}" -m 10 --connect-timeout 5 "$url" 2>/dev/null || echo "000")

        if [[ "$status_code" == "$expected_status" ]]; then
          echo "service_up{service=\"$service\",type=\"http\"} 1"
          echo "service_response_time{service=\"$service\",type=\"http\"} $response_time"
        else
          echo "service_up{service=\"$service\",type=\"http\"} 0"
          echo "service_response_time{service=\"$service\",type=\"http\"} 0"
        fi
      }

      # Function to check systemd service status
      check_systemd_service() {
        local service="$1"

        if ${pkgs.systemd}/bin/systemctl is-active --quiet "$service"; then
          echo "service_up{service=\"$service\",type=\"systemd\"} 1"
        else
          echo "service_up{service=\"$service\",type=\"systemd\"} 0"
        fi
      }

      # Check core system services
      for service in nginx prometheus grafana loki promtail; do
        check_systemd_service "$service"
      done

      # Check media services if they exist
      for service in jellyfin plex; do
        if ${pkgs.systemd}/bin/systemctl list-unit-files --quiet "$service.service" >/dev/null 2>&1; then
          check_systemd_service "$service"
        fi
      done

      # Check download services if they exist
      for service in sonarr radarr lidarr bazarr prowlarr transmission deluge; do
        if ${pkgs.systemd}/bin/systemctl list-unit-files --quiet "$service.service" >/dev/null 2>&1; then
          check_systemd_service "$service"
        fi
      done

      # HTTP health checks for web services
      check_http_service "nginx" "http://localhost" "200"
      check_http_service "prometheus" "http://localhost:9090/-/healthy" "200"
      check_http_service "grafana" "http://localhost:${toString constants.ports.grafana}/api/health" "200"

      # Check alertmanager if enabled
      if ${pkgs.systemd}/bin/systemctl is-enabled --quiet alertmanager >/dev/null 2>&1; then
        check_systemd_service "alertmanager"
        check_http_service "alertmanager" "http://localhost:${toString constants.ports.alertmanager}/-/healthy" "200"
      fi

      # Check additional services that might be running
      if ${pkgs.systemd}/bin/systemctl list-unit-files --quiet jellyfin.service >/dev/null 2>&1; then
        check_http_service "jellyfin" "http://localhost:${toString constants.ports.jellyfin}/health" "200"
      fi

      # Database connectivity checks
      echo "# HELP database_up Database connectivity (1=up, 0=down)"
      echo "# TYPE database_up gauge"

      # Check if PostgreSQL is running (for services that might use it)
      if ${pkgs.systemd}/bin/systemctl is-active --quiet postgresql >/dev/null 2>&1; then
        echo "database_up{database=\"postgresql\"} 1"
      else
        echo "database_up{database=\"postgresql\"} 0"
      fi

      # Process monitoring
      echo "# HELP process_count Number of processes for service"
      echo "# TYPE process_count gauge"

      # Count critical processes
      nginx_processes=$(${pkgs.procps}/bin/pgrep -c nginx || echo "0")
      echo "process_count{service=\"nginx\"} $nginx_processes"

      prometheus_processes=$(${pkgs.procps}/bin/pgrep -c prometheus || echo "0")
      echo "process_count{service=\"prometheus\"} $prometheus_processes"

      # Disk space checks for critical mounts
      echo "# HELP mount_available_bytes Available space on critical mounts"
      echo "# TYPE mount_available_bytes gauge"

      # Check critical mount points
      for mount in /srv /var/lib /mnt/media /mnt/downloads; do
        if mountpoint -q "$mount" 2>/dev/null; then
          available=$(${pkgs.coreutils}/bin/df --output=avail -B1 "$mount" | tail -n1 | tr -d ' ')
          echo "mount_available_bytes{mount=\"$mount\"} $available"
        fi
      done

    } > "$TEMP_FILE"

    # Atomically move temp file to final location
    mv "$TEMP_FILE" "$METRICS_FILE"
  '';
in {
  options.services.service-health = {
    enable = mkEnableOption "Service health monitoring";

    interval = mkOption {
      type = types.str;
      default = "30s";
      description = "Interval for service health checks";
    };

    services = mkOption {
      type = types.listOf types.str;
      default = ["nginx" "prometheus" "grafana"];
      description = "List of systemd services to monitor";
    };

    httpChecks = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          url = mkOption {
            type = types.str;
            description = "URL to check";
          };
          expectedStatus = mkOption {
            type = types.str;
            default = "200";
            description = "Expected HTTP status code";
          };
        };
      });
      default = {};
      example = {
        "grafana" = {
          url = "http://localhost:3000/api/health";
          expectedStatus = "200";
        };
      };
      description = "HTTP health check configurations";
    };
  };

  config = mkIf cfg.enable {
    # Service health monitoring service
    systemd.services.service-health = {
      description = "Service Health Monitoring";
      serviceConfig = {
        Type = "oneshot";
        User = "prometheus";
        Group = "prometheus";
        ExecStart = "${serviceHealthScript}";
      };
    };

    # Timer for regular health checks
    systemd.timers.service-health = {
      description = "Service Health Check Timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = cfg.interval;
        Persistent = true;
      };
    };

    # Ensure required packages are available
    environment.systemPackages = with pkgs; [
      curl
      procps
      coreutils
      util-linux
    ];
  };
}
