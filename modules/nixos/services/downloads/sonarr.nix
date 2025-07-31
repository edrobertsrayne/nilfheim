{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.sonarr;
  inherit (cfg.settings.server) port;
in {
  options.services.sonarr = {
    url = mkOption {
      type = types.str;
      default = "sonarr.${config.homelab.domain}";
      description = "URL for sonarr proxy host.";
    };
    apikey = mkOption {
      type = types.str;
      default = "e6619670253d4b17baaa8a640a3aafed";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      sonarr = {
        dataDir = "/srv/sonarr";
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
          inherit (cfg) apikey;
        };
      };

      prometheus.exporters.exportarr-sonarr = {
        enable = true;
        environment = {API_KEY = cfg.apikey;};
        url = "http://localhost:${toString port}";
        port = 9709;
      };

      prometheus = {
        scrapeConfigs = [
          {
            job_name = "sonarr";
            static_configs = [
              {
                targets = ["localhost:${toString config.services.prometheus.exporters.exportarr-sonarr.port}"];
              }
            ];
          }
        ];
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Sonarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "sonarr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
            widget = {
              type = "sonarr";
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
