{
  config,
  lib,
  pkgs,
  nilfheim,
  ...
}:
with lib; let
  cfg = config.services.deluge;
in {
  options.services.deluge = with types; {
    url = mkOption {
      type = str;
      default = "deluge.${config.domain.name}";
      description = "URL for deluge proxy.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      deluge = {
        web.enable = true;
        dataDir = mkDefault "/srv/deluge";
        declarative = true;
        config = {
          dont_count_slow_torrents = true;
          download_location = "/mnt/downloads";
          max_active_downloading = 10;
          max_active_limit = 15;
          max_active_seeding = 5;
          remove_seed_at_ratio = true;
          stop_seed_at_ratio = true;
          stop_seed_ratio = 2.0;
        };
        authFile = pkgs.writeText "deluge-auth" ''
          localclient:deluge:10
        '';
      };

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.web.port}";
          proxyWebsockets = true;
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Downloads";
          name = "Deluge";
          description = "Full-featured BitTorrent client";
          entry = {
            href = "https://${cfg.url}";
            icon = "deluge.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.web.port}";
            widget = {
              type = "deluge";
              url = "https://${cfg.url}";
              password = "{{HOMEPAGE_VAR_DELUGE_PASS}}";
              enableLeechProgress = true;
            };
          };
        }
      ];

      prometheus = {
        exporters.deluge = {
          enable = true;
          delugePasswordFile = pkgs.writeText "deluge-pass" ''deluge'';
        };
        scrapeConfigs = [
          {
            job_name = "deluge-exporter";
            static_configs = [
              {
                targets = ["localhost:${toString config.services.prometheus.exporters.deluge.port}"];
              }
            ];
          }
        ];
      };

      grafana.provision.dashboards.settings.providers = [
        {
          name = "Deluge";
          options.path = ../../monitoring/grafana/deluge.json;
        }
      ];
    };
  };
}
