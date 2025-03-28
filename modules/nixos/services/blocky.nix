{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.blocky;
  inherit (cfg.settings) ports;
in {
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
              ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
            };
            allowlists = {
              ads = ["https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt"];
            };
            clientGroupsBlock = {
              default = ["ads"];
            };
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
        provision.dashboards.settings.providers = [
          {
            name = "Blocky";
            options.path = ./grafana/blocky.json;
          }
        ];
      };
    };
    networking.firewall = {
      allowedTCPPorts = [ports.dns];
      allowedUDPPorts = [ports.dns];
    };
  };
}
