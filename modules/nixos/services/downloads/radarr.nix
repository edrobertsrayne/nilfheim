{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.radarr;
  inherit (cfg.settings.server) port;
in {
  options.services.radarr = {
    url = mkOption {
      type = types.str;
      default = "radarr.${config.homelab.domain}";
    };
    apikey = mkOption {
      type = types.str;
      default = "45f0ce64ed8b4d34b51908c60b7a70fc";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      radarr = {
        dataDir = "/srv/radarr";
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
          inherit (cfg) apikey;
        };
      };

      prometheus.exporters.exportarr-radarr = {
        enable = true;
        environment = {API_KEY = cfg.apikey;};
        url = "http://localhost:${toString port}";
        port = 9711;
      };

      prometheus = {
        scrapeConfigs = [
          {
            job_name = "radarr";
            static_configs = [
              {
                targets = ["localhost:${toString config.services.prometheus.exporters.exportarr-radarr.port}"];
              }
            ];
          }
        ];
      };

      # grafana.provision.dashboards.settings.providers = [
      #   {
      #     name = "Radarr";
      #     options.path = ../monitoring/grafana/radarr.json;
      #   }
      # ];

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Radarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "radarr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
            widget = {
              type = "radarr";
              url = "http://127.0.0.1:${toString port}";
              key = "${cfg.apikey}";
            };
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
