{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.prometheus.alertmanager;
  inherit (config) homelab;
in {
  options.services.prometheus.alertmanager = {
    url = mkOption {
      type = types.str;
      default = "alertmanager.${homelab.domain}";
      description = "URL for AlertManager proxy.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      prometheus.alertmanager = {
        configuration = {
          global = {
            smtp_smarthost = "localhost:587";
            smtp_from = "alertmanager@${homelab.domain}";
          };

          route = {
            group_by = ["alertname" "cluster" "service"];
            group_wait = "10s";
            group_interval = "10s";
            repeat_interval = "1h";
            receiver = "default";
            routes = [
              {
                match = {
                  severity = "critical";
                };
                receiver = "critical";
                repeat_interval = "5m";
              }
              {
                match = {
                  component = "promtail";
                };
                receiver = "logging";
              }
              {
                match = {
                  component = "loki";
                };
                receiver = "logging";
              }
              {
                match = {
                  component = "security";
                };
                receiver = "security";
              }
            ];
          };

          receivers = [
            {
              name = "default";
              webhook_configs = [
                {
                  url = "http://localhost:8080/webhook/general";
                }
              ];
            }
            {
              name = "critical";
              webhook_configs = [
                {
                  url = "http://localhost:8080/webhook/critical";
                }
              ];
            }
            {
              name = "logging";
              webhook_configs = [
                {
                  url = "http://localhost:8080/webhook/logging";
                }
              ];
            }
            {
              name = "security";
              webhook_configs = [
                {
                  url = "http://localhost:8080/webhook/security";
                }
              ];
            }
          ];

          inhibit_rules = [
            {
              source_match = {
                severity = "critical";
              };
              target_match = {
                severity = "warning";
              };
              equal = ["alertname" "cluster" "service"];
            }
          ];
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Monitoring";
          name = "AlertManager";
          description = "Alert management and routing system";
          entry = {
            href = "https://${cfg.url}";
            icon = "alertmanager.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.port}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
