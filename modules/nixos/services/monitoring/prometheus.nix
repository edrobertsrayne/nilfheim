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
          {
            job_name = "smartctl";
            static_configs = [
              {
                targets = ["localhost:9633"];
              }
            ];
            scrape_interval = "60s";
            scrape_timeout = "30s";
          }
        ];
        ruleFiles = [
          ./alerts/logging.yml
          ./alerts/health-checks.yml
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
          extraFlags = ["--collector.textfile.directory=/var/lib/prometheus-node-exporter-text-files"];
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
            description = "Metrics collection and monitoring system";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
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
          {
            name = "System Health";
            options.path = ./grafana/system-health.json;
          }
        ];
      };
    };
    system.persist.extraRootDirectories = ["/var/lib/${cfg.stateDir}"];
  };
}
