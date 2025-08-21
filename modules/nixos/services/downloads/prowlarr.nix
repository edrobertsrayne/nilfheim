{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.prowlarr;
  inherit (cfg.settings.server) port;
in {
  options.services.prowlarr = {
    url = mkOption {
      type = types.str;
      default = "prowlarr.${config.homelab.domain}";
      description = "URL for prowlarr proxy host.";
    };
    apikey = mkOption {
      type = types.str;
      default = "c20dce066e08419daaa4c2cbbe4ddcbe";
    };
  };

  config = mkIf cfg.enable {
    # Ensure prowlarr data directory has correct ownership
    systemd.tmpfiles.rules = [
      "d ${config.services.prowlarr.dataDir} 0755 prowlarr prowlarr - -"
    ];

    services = {
      prowlarr = {
        dataDir = "/srv/prowlarr";
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
          inherit (cfg) apikey;
        };
      };

      prometheus.exporters.exportarr-prowlarr = {
        enable = true;
        environment = {API_KEY = cfg.apikey;};
        url = "http://127.0.0.1:${toString port}";
        port = 9707;
      };
      prometheus = {
        scrapeConfigs = [
          {
            job_name = "prowlarr";
            static_configs = [
              {
                targets = ["localhost:${toString config.services.prometheus.exporters.exportarr-prowlarr.port}"];
              }
            ];
          }
        ];
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Downloads";
          name = "Prowlarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "prowlarr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
            description = "Indexer manager for Sonarr and Radarr";
            widget = {
              type = "prowlarr";
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
