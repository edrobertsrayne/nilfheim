{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.bazarr;
in {
  options.services.bazarr = {
    url = mkOption {
      type = types.str;
      default = "bazarr.${config.homelab.domain}";
      description = "URL for bazarr proxy host.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      bazarr.dataDir = "/srv/bazarr";

      # prometheus.exporters.exportarr-bazarr = {
      #   enable = true;
      #   url = "http://127.0.0.1:${toString cfg.listenPort}";
      #   port = 9708;
      # };
      #
      prometheus = {
        scrapeConfigs = [
          {
            job_name = "bazarr";
            static_configs = [
              {
                targets = ["localhost:${toString config.services.prometheus.exporters.exportarr-bazarr.port}"];
              }
            ];
          }
        ];
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media Management";
          name = "Bazarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "bazarr.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.listenPort}";
            description = "Subtitle downloader for movies and TV shows";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.listenPort}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
