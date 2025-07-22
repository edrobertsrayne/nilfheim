{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.promtail;
  lokiCfg = config.services.loki;
  inherit (config) homelab;
in {
  options.services.promtail = {
    url = mkOption {
      type = types.str;
      default = "promtail.${homelab.domain}";
      description = "URL for Promtail proxy.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      promtail = {
        configuration = {
          server = {
            http_listen_port = 9080;
            grpc_listen_port = 0;
          };
          
          positions = {
            filename = "/var/lib/promtail/positions.yaml";
          };
          
          clients = [
            {
              url = "http://127.0.0.1:${toString lokiCfg.configuration.server.http_listen_port}/loki/api/v1/push";
            }
          ];
          
          scrape_configs = [
            {
              job_name = "journal";
              journal = {
                max_age = "12h";
                labels = {
                  job = "systemd-journal";
                  host = config.networking.hostName;
                };
              };
              relabel_configs = [
                {
                  source_labels = ["__journal__systemd_unit"];
                  target_label = "unit";
                }
                {
                  source_labels = ["__journal__hostname"];
                  target_label = "hostname";
                }
                {
                  source_labels = ["__journal_priority_keyword"];
                  target_label = "level";
                }
              ];
            }
          ];
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Monitoring";
          name = "Promtail";
          entry = {
            href = "https://${cfg.url}";
            icon = "promtail.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.configuration.server.http_listen_port}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.configuration.server.http_listen_port}";
        };
      };
    };
    
    systemd.tmpfiles.rules = [
      "d /var/lib/promtail 0755 promtail promtail -"
    ];
    
    system.persist.extraRootDirectories = [
      "/var/lib/promtail"
    ];
    
    # Ensure promtail can read systemd journal
    users.users.promtail.extraGroups = [ "systemd-journal" ];
  };
}