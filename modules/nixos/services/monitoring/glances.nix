{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.glances;
in {
  options.services.glances = {
    url = mkOption {
      type = types.str;
      default = "glances.${config.homelab.domain}";
      description = "URL for glances proxy host.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      homepage-dashboard = {
        homelabServices = [
          {
            group = "Monitoring";
            name = "glances";
            entry = {
              href = "https://${cfg.url}";
              icon = "glances.svg";
              siteMonitor = "http://127.0.0.1:${toString cfg.port}";
              description = "System monitoring and performance metrics";
            };
          }
        ];
      };

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
