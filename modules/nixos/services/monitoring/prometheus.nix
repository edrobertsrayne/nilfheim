{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.prometheus;
  inherit (config) homelab;
  inherit (cfg.exporters) node;
in {
  options.services.prometheus = {
    url = mkOption {
      type = types.str;
      default = "prometheus.${homelab.domain}";
      description = "URL for prometheus proxy.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      prometheus = {
        globalConfig.scrape_interval = "10s";
        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = ["localhost:${toString node.port}"];
              }
            ];
          }
          {
            job_name = "promtail";
            static_configs = [
              {
                targets = ["localhost:9080"];
              }
            ];
          }
          {
            job_name = "alertmanager";
            static_configs = [
              {
                targets = ["localhost:9093"];
              }
            ];
          }
        ];
        ruleFiles = [
          ./alerts/logging.yml
          ../backup/alerts/zfs-snapshots.yml
        ];
        alertmanagers = [
          {
            static_configs = [
              {
                targets = ["localhost:9093"];
              }
            ];
          }
        ];
        exporters.node = {
          enable = true;
          enabledCollectors = ["textfile"];
          extraFlags = [
            "--collector.textfile.directory=/var/lib/zfs-snapshots"
          ];
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Monitoring";
          name = "Prometheus";
          entry = {
            href = "https://${cfg.url}";
            icon = "prometheus.svg";
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

            # WebSocket support headers
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;

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
      grafana.provision = {
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://localhost:${builtins.toString cfg.port}";
            editable = true;
            uid = "PBFA97CFB590B2093";
          }
        ];
        dashboards.settings.providers = [
          {
            name = "Node Exporter";
            options.path = ./grafana/node.json;
          }
        ];
      };
    };
    system.persist.extraRootDirectories = ["/var/lib/${cfg.stateDir}"];
  };
}
