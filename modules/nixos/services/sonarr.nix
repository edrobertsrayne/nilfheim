{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.sonarr;
  inherit (cfg.settings.server) port;
in {
  options.services.sonarr = {
    url = mkOpt types.str "sonarr.${config.homelab.domain}" "URL for sonarr proxy host.";
  };

  config = mkIf cfg.enable {
    services = {
      sonarr = {
        dataDir = "/srv/sonarr";
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Sonarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "sonarr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
            widget = {
              type = "sonarr";
              url = "http://127.0.0.1:${toString port}";
              key = "{{HOMEPAGE_VAR_SONARR_APIKEY}}";
              enableQueue = true;
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
