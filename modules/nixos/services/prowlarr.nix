{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.prowlarr;
  inherit (cfg.settings.server) port;
in {
  options.services.prowlarr = {
    url = mkOpt types.str "prowlarr.${config.homelab.domain}" "URL for prowlarr proxy host.";
  };

  config = mkIf cfg.enable {
    services = {
      prowlarr = {
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Downloads";
          name = "Prowlarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "prowlarr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
            widget = {
              type = "prowlarr";
              url = "http://127.0.0.1:${toString port}";
              key = "{{HOMEPAGE_VAR_PROWLARR_APIKEY}}";
            };
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
  };
}
