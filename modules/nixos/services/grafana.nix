{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  inherit (config) homelab;
  cfg = config.services.grafana;
in {
  options.services.grafana = {
    url = mkOpt types.str "grafana.${homelab.domain}" "URL for Grafana proxy.";
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
            siteMonitor = "https://${cfg.url}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.settings.server.http_port}";
        };
      };
    };
  };
}
