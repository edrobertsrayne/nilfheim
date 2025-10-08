{
  config,
  lib,
  nilfheim,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.services.n8n;
in {
  options.services.n8n = {
    url = mkOption {
      type = types.str;
      default = "n8n.${config.domain.name}";
      description = "URL for n8n proxy.";
    };

    port = mkOption {
      type = types.port;
      default = 5678;
      description = "Port for n8n web interface.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      n8n = {
        openFirewall = false; # We use nginx proxy
        webhookUrl = cfg.url;

        settings = {
          inherit (cfg) port;
          # Security settings
          security = {
            excludeEndpoints = "metrics";
          };
          # Webhook settings
          endpoints = {
            webhook = "webhook";
            webhookWaiting = "webhook-waiting";
            webhookTest = "webhook-test";
          };
          # Database settings - uses SQLite by default in /var/lib/n8n
          database = {
            type = "sqlite";
            sqlite = {
              database = "database.sqlite";
            };
          };
        };
      };

      # Nginx proxy configuration
      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            # n8n specific headers for webhook functionality
            proxy_set_header Connection $connection_upgrade;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Accept-Encoding gzip;
          '';
        };
      };

      # Homepage dashboard integration
      homepage-dashboard.homelabServices = [
        {
          group = "Utilities";
          name = "n8n";
          entry = {
            href = "https://${cfg.url}";
            icon = "n8n.svg";
            siteMonitor = "https://${cfg.url}";
            description = "Workflow automation platform";
          };
        }
      ];
    };
  };
}
