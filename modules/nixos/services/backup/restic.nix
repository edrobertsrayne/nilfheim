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
      default = ["/persist" "/srv" "/var/lib/private"];
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
        default = false;
        description = "Enable Prometheus backup monitoring (disabled in favor of Loki)";
      };

      port = mkOption {
        type = types.port;
        default = 9753;
        description = "Port for restic exporter metrics";
      };
    };
  };

  config = mkIf cfg.enable {
    # Configure restic backup service using the built-in module
    services.restic.backups.system = {
      initialize = true;
      inherit (cfg) repository passwordFile paths exclude;

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

    # System configuration
    systemd = {
      # Ensure backup directory exists with proper permissions
      tmpfiles.rules = [
        "d ${cfg.repository} 0750 root root -"
        "d /etc/restic 0755 root root -"
      ];

      services = {
        # Generate a secure password if it doesn't exist
        restic-init-password = {
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

        # Extend service configuration for better performance
        "restic-backups-system" = {
          serviceConfig = {
            # Resource limits to prevent system impact
            MemoryMax = "2G";
            CPUQuota = "50%";
            IOSchedulingClass = 3; # Idle priority
            Nice = 10;
          };
        };
      };
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
  };
}
