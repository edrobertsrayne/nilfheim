{
  config,
  lib,
  ...
}:
with lib; let
  service = "jellyseerr";
  cfg = config.services."${service}";
in {
  options.services."${service}" = {
    url = mkOption {
      type = types.str;
      default = "${service}.${config.homelab.domain}";
      description = "URL for ${service} proxy host.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Jellyseerr";
          entry = {
            href = "https://${cfg.url}";
            icon = "jellyseerr.svg";
            siteMonitor = "https://${cfg.url}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
