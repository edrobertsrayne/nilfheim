{
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) homelab;
  cfg = config.services.grafana;
in {
  options.services.grafana = {
    url = mkOption {
      type = types.str;
      default = "grafana.${homelab.domain}";
      description = "URL for Grafana proxy.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      grafana = {
        dataDir = "/srv/grafana";
        settings = {
          server = {
            domain = "${cfg.url}";
          };
        };
        provision.enable = true;
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Monitoring";
          name = "Grafana";
          entry = {
            href = "https://${cfg.url}";
            icon = "grafana.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.settings.server.http_port}";
            description = "Metrics dashboards and visualization";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.settings.server.http_port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
