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
          security = {
            # Prevent XSS attacks
            content_type_protection = true;
            x_content_type_options = "nosniff";
            x_xss_protection = true;
            strict_transport_security = true;
            strict_transport_security_max_age_seconds = 31536000;
            strict_transport_security_preload = true;
            strict_transport_security_subdomains = true;
            # Disable embedding in iframes
            allow_embedding = false;
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
