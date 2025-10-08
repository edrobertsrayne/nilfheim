# Stirling PDF Service Configuration
#
# Database: Uses embedded H2 database stored in /var/lib/private/stirling-pdf/configs/
# Persistence: Data is persisted via /var/lib/private mount in ZFS persist volume
#
# Database Reset Procedure (if schema migration fails):
#   1. Stop service: systemctl stop stirling-pdf.service
#   2. Backup data: tar czf /tmp/stirling-pdf-backup-$(date +%Y%m%d).tar.gz -C /var/lib/private/stirling-pdf/configs .
#   3. Remove databases: rm -f /var/lib/private/stirling-pdf/configs/*.db /var/lib/private/stirling-pdf/configs/*.trace.db
#   4. Remove old backups (if schema mismatch): mv /var/lib/private/stirling-pdf/configs/backup /var/lib/private/stirling-pdf/configs/backup.old
#   5. Restart service: systemctl start stirling-pdf.service
#
# Note: Stirling PDF will automatically create fresh database with correct schema on startup
{
  config,
  lib,
  nilfheim,
  ...
}:
with lib; let
  cfg = config.services.stirling-pdf;
in {
  options.services.stirling-pdf = {
    url = mkOption {
      type = types.str;
      default = "stirling-pdf.${config.domain.name}";
      description = "URL for Stirling PDF proxy host.";
    };
    port = mkOption {
      type = types.port;
      default = 8081;
      description = "Port for Stirling PDF service to listen on.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      stirling-pdf.environment = {
        INSTALL_BOOK_AND_ADVANCED_HTML_OPS = "true";
        SERVER_PORT = cfg.port;
      };

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };

      # Homepage dashboard integration
      homepage-dashboard.homelabServices = [
        {
          group = "Utilities";
          name = "Stirling PDF";
          entry = {
            href = "https://${cfg.url}";
            icon = "stirling-pdf.svg";
            siteMonitor = "https://${cfg.url}";
            description = "PDF manipulation toolkit";
          };
        }
      ];
    };
  };
}
