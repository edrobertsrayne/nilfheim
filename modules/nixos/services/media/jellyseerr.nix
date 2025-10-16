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
      default = "${service}.${config.domain.name}";
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
            description = "Media request management for Jellyfin";
          };
        }
      ];

      cloudflared.tunnels."${config.domain.tunnel}".ingress."${cfg.url}" = "http://127.0.0.1:${toString cfg.port}";
    };
  };
}
