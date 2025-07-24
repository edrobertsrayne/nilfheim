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
          extraConfig = ''
            # Cloudflare tunnel compatibility headers
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;

            # Proxy timeouts for long-running connections
            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;

            # Buffer settings for better performance
            proxy_buffering off;
            proxy_request_buffering off;

            # Security headers
            add_header X-Frame-Options SAMEORIGIN;
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";
          '';
        };
      };
    };
  };
}
