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
            # Systemd journal logs
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
                {
                  source_labels = ["__journal_container_name"];
                  target_label = "container";
                }
              ];
            }

            # Nginx access logs
            {
              job_name = "nginx-access";
              static_configs = [
                {
                  targets = ["localhost"];
                  labels = {
                    job = "nginx-access";
                    host = config.networking.hostName;
                    __path__ = "/var/log/nginx/access.log";
                  };
                }
              ];
              pipeline_stages = [
                {
                  regex = {
                    expression = "^(?P<remote_addr>[\\w\\.\\:]+) - (?P<remote_user>\\S+) \\[(?P<time_local>[^\\]]+)\\] \"(?P<method>\\S+) (?P<path>\\S+) (?P<protocol>\\S+)\" (?P<status>\\d+) (?P<bytes_sent>\\d+) \"(?P<referer>[^\"]*)\" \"(?P<user_agent>[^\"]*)\"";
                  };
                }
                {
                  labels = {
                    method = "";
                    status = "";
                    path = "";
                  };
                }
                {
                  timestamp = {
                    source = "time_local";
                    format = "02/Jan/2006:15:04:05 -0700";
                  };
                }
              ];
            }

            # Nginx error logs
            {
              job_name = "nginx-error";
              static_configs = [
                {
                  targets = ["localhost"];
                  labels = {
                    job = "nginx-error";
                    host = config.networking.hostName;
                    __path__ = "/var/log/nginx/error.log";
                  };
                }
              ];
            }

            # Jellyfin logs
            {
              job_name = "jellyfin";
              static_configs = [
                {
                  targets = ["localhost"];
                  labels = {
                    job = "jellyfin";
                    host = config.networking.hostName;
                    __path__ = "/srv/jellyfin/log/*.log";
                  };
                }
              ];
            }

            # *arr stack logs (Sonarr, Radarr, Lidarr, Readarr, Prowlarr)
            {
              job_name = "arr-services";
              static_configs = [
                {
                  targets = ["localhost"];
                  labels = {
                    job = "arr-services";
                    host = config.networking.hostName;
                    __path__ = "/srv/{sonarr,radarr,lidarr,readarr,prowlarr}/logs/*.txt";
                  };
                }
              ];
              pipeline_stages = [
                {
                  regex = {
                    expression = "^(?P<timestamp>\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}\\.\\d+)\\|(?P<level>\\w+)\\|(?P<logger>[^\\|]*)\\|(?P<message>.*)$";
                  };
                }
                {
                  labels = {
                    level = "";
                    logger = "";
                  };
                }
                {
                  timestamp = {
                    source = "timestamp";
                    format = "2006-01-02 15:04:05.0";
                  };
                }
              ];
            }

            # Kavita logs
            {
              job_name = "kavita";
              static_configs = [
                {
                  targets = ["localhost"];
                  labels = {
                    job = "kavita";
                    host = config.networking.hostName;
                    __path__ = "/srv/kavita/config/logs/*.log";
                  };
                }
              ];
            }

            # Bazarr logs (if they exist in expected location)
            {
              job_name = "bazarr";
              static_configs = [
                {
                  targets = ["localhost"];
                  labels = {
                    job = "bazarr";
                    host = config.networking.hostName;
                    __path__ = "/srv/bazarr/log/*.log";
                  };
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
            description = "Log collection agent for Loki";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.configuration.server.http_listen_port}";
          proxyWebsockets = true;
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/promtail 0755 promtail promtail -"
    ];

    system.persist.extraRootDirectories = [
      "/var/lib/promtail"
    ];

    # Ensure promtail can read various log sources
    users.users.promtail.extraGroups = [
      "systemd-journal" # For systemd journal access
      "nginx" # For nginx log access
      "jellyfin" # For Jellyfin log access
      "sonarr" # For Sonarr log access
      "radarr" # For Radarr log access
      "lidarr" # For Lidarr log access
      "readarr" # For Readarr log access
      "prowlarr" # For Prowlarr log access
      "bazarr" # For Bazarr log access
      "kavita" # For Kavita log access
    ];
  };
}
