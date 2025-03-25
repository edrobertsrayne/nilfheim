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
    subdomain = mkOpt types.str "prometheus" "Subdomain for prometheus proxy.";
  };

  config = mkIf cfg.enable {
    services.prometheus = {
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
    services.nginx.virtualHosts."${cfg.subdomain}.${homelab.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString prometheus.port}";
      };
    };
  };
}
