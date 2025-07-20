{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.sonarr;
  inherit (cfg.settings.server) port;
in {
  options.services.sonarr = {
    url = mkOption {
      type = types.str;
      default = "sonarr.${config.homelab.domain}";
      description = "URL for sonarr proxy host.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

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
            };
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
  };
}
