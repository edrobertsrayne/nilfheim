{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  constants = import ../../../../lib/constants.nix;
  cfg = config.services.backup.restic;
in {
  options.services.backup.restic = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable restic backup service";
    };

    repository = mkOption {
      type = types.str;
      default = "${constants.paths.backup}/restic";
      description = "Path to restic repository";
    };

    passwordFile = mkOption {
      type = types.str;
      default = "/etc/restic/password";
      description = "Path to file containing restic repository password";
    };

    paths = mkOption {
      type = types.listOf types.str;
      default = ["/persist" "/srv"];
      description = "Paths to backup";
    };

    exclude = mkOption {
      type = types.listOf types.str;
      default = [
        "/persist/cache"
        "/persist/tmp"
        "/srv/*/cache"
        "/srv/*/tmp"
        "/srv/*/logs"
        "**/.cache"
        "**/cache"
        "**/tmp"
        "**/*.log"
        "**/logs"
      ];
      description = "Paths to exclude from backup";
    };

    schedule = mkOption {
      type = types.str;
      default = "daily";
      description = "Backup schedule (systemd calendar format)";
    };

    retention = mkOption {
      type = types.attrs;
      default = {
        keep-daily = 14;
        keep-weekly = 8;
        keep-monthly = 6;
        keep-yearly = 2;
      };
      description = "Backup retention policy";
    };

    monitoring = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable backup monitoring and alerting";
      };

      port = mkOption {
        type = types.port;
        default = 9753;
        description = "Port for restic exporter metrics";
      };
    };
  };

  config = mkIf cfg.enable {
    # Ensure backup directory exists with proper permissions
    systemd.tmpfiles.rules = [
      "d ${cfg.repository} 0750 root root -"
      "d /etc/restic 0755 root root -"
    ] ++ (lib.optionals config.services.grafana.enable [
      "d /etc/grafana/dashboards/restic 0755 grafana grafana -"
    ]);

    # Generate a secure password if it doesn't exist
    systemd.services.restic-init-password = {
      description = "Initialize restic repository password";
      wantedBy = ["multi-user.target"];
      before = ["restic-backups-system.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
      };
      script = ''
        if [ ! -f "${cfg.passwordFile}" ]; then
          echo "Generating new restic repository password..."
          ${pkgs.openssl}/bin/openssl rand -base64 32 > "${cfg.passwordFile}"
          chmod 600 "${cfg.passwordFile}"
        fi
      '';
    };

    # Configure restic backup service using the built-in module
    services.restic.backups.system = {
      initialize = true;
      repository = cfg.repository;
      passwordFile = cfg.passwordFile;
      paths = cfg.paths;
      exclude = cfg.exclude;

      # Backup schedule
      timerConfig = {
        OnCalendar = cfg.schedule;
        Persistent = true;
        RandomizedDelaySec = "1h";
      };

      # Pre-backup script
      backupPrepareCommand = ''
        echo "Starting backup of: ${builtins.concatStringsSep ", " cfg.paths}"
        echo "Repository: ${cfg.repository}"
        echo "Timestamp: $(date)"
      '';

      # Post-backup cleanup
      backupCleanupCommand = let
        retentionArgs = builtins.concatStringsSep " " (
          lib.mapAttrsToList (key: value: "--${key} ${toString value}") cfg.retention
        );
      in ''
        echo "Cleaning up old snapshots..."
        ${pkgs.restic}/bin/restic forget --prune ${retentionArgs}
        echo "Backup completed: $(date)"
      '';

      # Additional restic options
      extraOptions = [
        "--verbose"
        "--exclude-caches"
        "--one-file-system"
      ];
    };

    # Extend service configuration for better performance
    systemd.services."restic-backups-system" = {
      serviceConfig = {
        # Resource limits to prevent system impact
        MemoryMax = "2G";
        CPUQuota = "50%";
        IOSchedulingClass = 3; # Idle priority
        Nice = 10;
      };
    };

    # Grafana dashboard integration
    services.grafana.provision.dashboards.settings.providers = mkIf config.services.grafana.enable [
      {
        name = "restic-backup";
        type = "file";
        updateIntervalSeconds = 30;
        options.path = "/etc/grafana/dashboards/restic";
      }
    ];


    environment.etc."grafana/dashboards/restic/restic-backup.json" = mkIf config.services.grafana.enable {
      text = builtins.readFile ./grafana-dashboard.json;
      user = "grafana";
      group = "grafana";
      mode = "0644";
    };

    # Homepage dashboard integration
    services.homepage-dashboard.homelabServices = mkIf config.services.homepage-dashboard.enable [
      {
        group = constants.serviceGroups.utilities;
        name = "Backup Status";
        entry = {
          href = "https://grafana.${config.homelab.domain}/d/restic-backup/restic-backup-monitoring";
          icon = "mdi-backup-restore";
          description = "System backup monitoring and status";
        };
      }
    ];

    # Optional: Prometheus monitoring
    services.prometheus.exporters.restic = mkIf cfg.monitoring.enable {
      enable = true;
      port = cfg.monitoring.port;
      repository = cfg.repository;
      passwordFile = cfg.passwordFile;
    };

    # Firewall for monitoring
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = mkIf cfg.monitoring.enable [
      cfg.monitoring.port
    ];

    # Prometheus scrape configuration
    services.prometheus.scrapeConfigs = mkIf (cfg.monitoring.enable && config.services.prometheus.enable) [
      {
        job_name = "restic-backup";
        static_configs = [
          {
            targets = ["localhost:${toString cfg.monitoring.port}"];
            labels = {
              instance = config.networking.hostName;
              service = "restic-backup";
            };
          }
        ];
      }
    ];
  };
}