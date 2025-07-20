{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.radarr;
  inherit (cfg.settings.server) port;
in {
  options.services.radarr = {
    url = mkOption {
      type = types.str;
      default = "radarr.${config.homelab.domain}";
    };
    apikey = mkOption {
      type = types.str;
      default = "45f0ce64ed8b4d34b51908c60b7a70fc";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      radarr = {
        dataDir = "/srv/radarr";
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
          inherit (cfg) apikey;
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
              key = "${cfg.apikey}";
            };
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
