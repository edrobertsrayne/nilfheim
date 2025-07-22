{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.loki;
  inherit (config) homelab;
in {
  options.services.loki = {
    url = mkOption {
      type = types.str;
      default = "loki.${homelab.domain}";
      description = "URL for Loki proxy.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      loki = {
        dataDir = "/srv/loki";
        configuration = {
          server = {
            http_listen_port = 3100;
            grpc_listen_port = 9096;
          };
          
          auth_enabled = false;
          
          ingester = {
            lifecycler = {
              address = "127.0.0.1";
              ring = {
                kvstore = {
                  store = "inmemory";
                };
                replication_factor = 1;
              };
              final_sleep = "0s";
            };
            chunk_idle_period = "1h";
            max_chunk_age = "1h";
            chunk_target_size = 1048576;
            chunk_retain_period = "30s";
          };
          
          schema_config = {
            configs = [{
              from = "2020-10-24";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }];
          };
          
          storage_config = {
            tsdb_shipper = {
              active_index_directory = "/srv/loki/tsdb-index";
              cache_location = "/srv/loki/tsdb-cache";
            };
            filesystem = {
              directory = "/srv/loki/chunks";
            };
          };
          
          limits_config = {
            reject_old_samples = true;
            reject_old_samples_max_age = "168h";
            retention_period = "744h"; # 31 days
          };
          
          table_manager = {
            retention_deletes_enabled = false;
            retention_period = "0s";
          };
          
          compactor = {
            working_directory = "/srv/loki/compactor";
            compactor_ring = {
              kvstore = {
                store = "inmemory";
              };
            };
          };
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Monitoring";
          name = "Loki";
          entry = {
            href = "https://${cfg.url}";
            icon = "loki.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.configuration.server.http_listen_port}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.configuration.server.http_listen_port}";
        };
      };
      
      grafana.provision = {
        datasources.settings.datasources = [
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://localhost:${toString cfg.configuration.server.http_listen_port}";
            editable = true;
            uid = "LOKI001";
          }
        ];
      };
    };
    
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 loki loki -"
      "d ${cfg.dataDir}/chunks 0755 loki loki -"
      "d ${cfg.dataDir}/tsdb-index 0755 loki loki -"
      "d ${cfg.dataDir}/tsdb-cache 0755 loki loki -" 
      "d ${cfg.dataDir}/compactor 0755 loki loki -"
    ];
    
    system.persist.extraRootDirectories = [
      "/srv/loki"
    ];
  };
}