{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.nixos.services.prometheus;
  inherit (config) homelab;
  inherit (config.services.prometheus.exporters) node;
  inherit (config.services) prometheus;
in {
  options.nixos.services.prometheus = {
    enable = mkEnableOption "Whether to enable prometheus.";
    url = mkOpt types.str "prometheus.${homelab.domain}" "URL for prometheus proxy.";
  };

  config = mkIf cfg.enable {
    services = {
      prometheus = {
        enable = true;
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
          proxyPass = "http://127.0.0.1:${toString prometheus.port}";
        };
      };
      grafana.provision = {
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://localhost:${builtins.toString prometheus.port}";
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
    modules.system.persist.extraRootDirectories = ["/var/lib/${prometheus.stateDir}"];
  };
}
