{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.prometheus;
  inherit (config) homelab;
  inherit (cfg.exporters) node;
in {
  options.services.prometheus = {
    url = mkOpt types.str "prometheus.${homelab.domain}" "URL for prometheus proxy.";
  };

  config = mkIf cfg.enable {
    services = {
      prometheus = {
        globalConfig.scrape_interval = "10s";
        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = ["localhost:${toString node.port}"];
              }
            ];
          }
        ];
        exporters.node = {
          enable = true;
        };
      };
      nginx.virtualHosts."${cfg.url}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
        };
      };
      grafana.provision = {
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://localhost:${builtins.toString cfg.port}";
            editable = true;
            uid = "PBFA97CFB590B2093";
          }
        ];
        dashboards.settings.providers = [
          {
            name = "Node Exporter";
            options.path = ./grafana/node.json;
          }
        ];
      };
    };
    modules.system.persist.extraRootDirectories = ["/var/lib/${cfg.stateDir}"];
  };
}
