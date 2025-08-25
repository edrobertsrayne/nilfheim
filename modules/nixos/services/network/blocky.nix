{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.blocky;
  inherit (cfg.settings) ports;
  constants = import ../../../../lib/constants.nix;
in {
  options.services.blocky.postgres = {
    user = mkOption {
      type = types.str;
      default = "blocky";
      description = "PostgreSQL user for Blocky query logging";
    };
    password = mkOption {
      type = types.str;
      default = "blocky";
      description = "PostgreSQL password for Blocky query logging";
    };
    database = mkOption {
      type = types.str;
      default = "blocky_logs";
      description = "PostgreSQL database name for Blocky query logging";
    };
  };
  config = mkIf cfg.enable {
    services = {
      blocky = {
        settings = {
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
          queryLog = {
            type = "postgresql";
            target = "postgres://${cfg.postgres.user}:${cfg.postgres.password}@localhost:${toString constants.ports.postgresql}/${cfg.postgres.database}?sslmode=disable";
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
        };
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
      grafana = {
        declarativePlugins = with pkgs.grafanaPlugins; [grafana-piechart-panel];
        settings.panels.disable_sanitize_html = true;
        provision = {
          datasources.settings.datasources = [
            {
              name = "PostgreSQL Blocky Logs";
              type = "postgres";
              uid = "postgres-blocky-logs";
              url = "localhost:${toString constants.ports.postgresql}";
              inherit (cfg.postgres) database user;
              secureJsonData.password = cfg.postgres.password;
              jsonData = {
                sslmode = "disable";
                postgresVersion = 1600;
                timescaledb = false;
              };
              isDefault = false;
              access = "proxy";
            }
          ];
          dashboards.settings.providers = [
            {
              name = "Blocky";
              options.path = ../monitoring/grafana/blocky.json;
            }
            {
              name = "Blocky Enhanced";
              options.path = ../monitoring/grafana/blocky-enhanced.json;
            }
            {
              name = "Blocky PostgreSQL Analytics";
              options.path = ../monitoring/grafana/blocky-postgres.json;
            }
          ];
        };
      };
    };
    networking.firewall = {
      allowedTCPPorts = [ports.dns];
      allowedUDPPorts = [ports.dns];
    };
  };
}
