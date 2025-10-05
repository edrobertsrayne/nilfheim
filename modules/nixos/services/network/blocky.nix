{
  config,
  lib,
  pkgs,
  nilfheim,
  ...
}:
with lib; let
  cfg = config.services.blocky;
  inherit (cfg.settings) ports;
in {
  options.services.blocky = {
    database = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable PostgreSQL database integration for query logging.";
      };

      name = mkOption {
        type = types.str;
        default = "blocky_logs";
        description = "Database name for Blocky query logging.";
      };

      user = mkOption {
        type = types.str;
        default = "blocky";
        description = "Database user for Blocky query logging.";
      };

      password = mkOption {
        type = types.str;
        default = "blocky";
        description = "Database password for Blocky query logging.";
      };
    };

    # Legacy options for backward compatibility
    postgres = {
      user = mkOption {
        type = types.str;
        default = cfg.database.user;
        description = "Legacy option - use services.blocky.database.user instead";
      };
      password = mkOption {
        type = types.str;
        default = cfg.database.password;
        description = "Legacy option - use services.blocky.database.password instead";
      };
      database = mkOption {
        type = types.str;
        default = cfg.database.name;
        description = "Legacy option - use services.blocky.database.name instead";
      };
    };
  };
  config = mkIf cfg.enable {
    # Database setup (only if PostgreSQL is enabled and database integration is enabled)
    services.postgresql = mkIf (cfg.database.enable && config.services.postgresql.enable) {
      ensureDatabases = [cfg.database.name];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureClauses = {
            superuser = false;
            createdb = true;
          };
        }
      ];
      initialScript = pkgs.writeText "blocky-db-init.sql" ''
        \c ${cfg.database.name};
        GRANT ALL ON SCHEMA public TO ${cfg.database.user};
        GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${cfg.database.user};
        GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${cfg.database.user};
      '';
    };

    services = {
      blocky = {
        settings =
          {
            ports = {
              dns = 53;
              http = 4000;
            };
            upstreams.groups.default = [
              "https://one.one.one.one/dns-query"
            ];
            prometheus = {
              enable = true;
              path = "/metrics";
            };
            caching = {
              minTime = "5m";
              maxTime = "30m";
              prefetching = true;
            };
            bootstrapDns = {
              upstream = "https://one.one.one.one/dns-query";
              ips = ["1.1.1.1" "1.0.0.1"];
            };
            blocking = {
              denylists = {
                ads = [
                  "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                  "https://small.oisd.nl/rpz"
                  "https://raw.githubusercontent.com/lassekongo83/Frellwits-filter-lists/master/Frellwits-Swedish-Hosts-File.txt"
                  "https://v.firebog.net/hosts/AdguardDNS.txt"
                  (pkgs.writeText "adblock.txt" ''
                    mediavisor.doubleclick.net
                    affiliationjs.s3.amazonaws.com
                    afs.googlesyndication.com
                  '')
                ];
                trackers = [
                  "https://v.firebog.net/hosts/Easyprivacy.txt"
                  "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/native.amazon.txt"
                  "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/native.apple.txt"
                  "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/native.huawei.txt"
                  "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/native.winoffice.txt"
                  "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/native.tiktok.extended.txt"
                  "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/native.lgwebos.txt"
                  "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/native.vivo.txt"
                  "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/native.oppo-realme.txt"
                  "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/native.xiaomi.txt"
                  (pkgs.writeText "trackers.txt" ''
                    api.luckyorange.com
                    cdn.luckyorange.com
                    w1.luckyorange.com
                    ads.facebook.com
                    advertising.twitter.com
                    widgets.pinterest.com
                    samsung-com.112.2o7.net
                    api.bugsnag.com
                    app.bugsnag.com
                    browser.sentry-cdn.com
                    app.getsentry.com
                    adm.hotjar.com
                    identify.hotjar.com
                    insights.hotjar.com
                    surveys.hotjar.com
                    tools.mouseflow.com
                    cdn-test.mouseflow.com
                    realtime.luckyorange.com
                    claritybt.freshmarketer.com
                    fwtracks.freshmarketer.com
                    udcm.yahoo.com
                    log.fc.yahoo.com
                    adtech.yahooinc.com
                    appmetrica.yandex.ru
                    metrika.yandex.ru
                  '')
                ];
              };
              allowlists = {
                ads = [
                  (pkgs.writeText "whitelist.txt" ''
                    clients4.google.com
                    clients2.google.com
                    s.youtube.com
                    video-stats.youtube.com
                    www.googleapis.com
                    youtubei.googleapis.com
                    oauthaccountmanager.googleapis.com
                    android.clients.google.com
                    reminders-pa.googleapis.com
                    firestore.googleapis.com
                    gstaticadssl.l.google.com
                    googleapis.l.google.com
                    dl.google.com
                    redirector.gvt1.com
                    mtalk.google.com
                  '')
                ];
              };
              clientGroupsBlock = {
                default = ["ads" "trackers"];
              };
            };
          }
          // (lib.optionalAttrs (cfg.database.enable && config.services.postgresql.enable) {
            queryLog = {
              type = "postgresql";
              target = "postgres://${cfg.database.user}:${cfg.database.password}@localhost:${toString nilfheim.constants.ports.postgresql}/${cfg.database.name}?sslmode=disable";
              logRetentionDays = 90; # Keep logs for 3 months
              flushInterval = "30s"; # Flush to database every 30 seconds
              fields = [
                "clientIP"
                "clientName"
                "responseReason"
                "responseAnswer"
                "question"
                "duration"
              ];
            };
          });
      };
      prometheus.scrapeConfigs = [
        {
          job_name = "blocky";
          static_configs = [
            {
              targets = ["localhost:${toString ports.http}"];
            }
          ];
        }
      ];
      grafana = mkMerge [
        {
          declarativePlugins = with pkgs.grafanaPlugins; [grafana-piechart-panel];
          settings.panels.disable_sanitize_html = true;
        }
        (mkIf (cfg.database.enable && config.services.postgresql.enable) {
          provision = {
            datasources.settings.datasources = [
              {
                name = "PostgreSQL Blocky Logs";
                type = "postgres";
                uid = "postgres-blocky-logs";
                url = "127.0.0.1:${toString nilfheim.constants.ports.postgresql}";
                database = cfg.database.name;
                inherit (cfg.database) user;
                secureJsonData.password = cfg.database.password;
                jsonData = {
                  sslmode = "disable";
                  postgresVersion = 1600;
                  timescaledb = false;
                  connMaxLifetime = 14400;
                  maxOpenConns = 100;
                  maxIdleConns = 100;
                };
                isDefault = false;
                access = "proxy";
                editable = true;
              }
            ];
            dashboards.settings.providers = [
              {
                name = "Blocky DNS Analytics";
                options.path = ../monitoring/grafana/blocky-analytics.json;
              }
            ];
          };
        })
      ];
    };
    networking.firewall = {
      allowedTCPPorts = [ports.dns];
      allowedUDPPorts = [ports.dns];
    };
  };
}
