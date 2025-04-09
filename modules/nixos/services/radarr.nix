{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.radarr;
  inherit (cfg.settings.server) port;
in {
  options.services.radarr = {
    url = mkOpt' types.str "radarr.${config.homelab.domain}";
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      radarr = {
        dataDir = "/srv/radarr";
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Radarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "radarr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
            widget = {
              type = "radarr";
              url = "http://127.0.0.1:${toString port}";
              key = "{{HOMEPAGE_VAR_RADARR_APIKEY}}";
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
