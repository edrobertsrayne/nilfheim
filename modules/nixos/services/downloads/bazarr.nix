{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.bazarr;
in {
  options.services.bazarr = {
    url = mkOption {
      type = types.str;
      default = "bazarr.${config.homelab.domain}";
      description = "URL for bazarr proxy host.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      bazarr.dataDir = "/srv/bazarr";

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Bazarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "bazarr.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.listenPort}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.listenPort}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
