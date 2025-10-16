{
  config,
  lib,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.services.plex;
in {
  options.services.plex = {
    url = mkOption {
      type = types.str;
      default = "plex.${config.domain.name}";
      description = "URL for Plex proxy.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      plex = {
        dataDir = "/srv/plex";
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Plex";
          description = "Media server with rich client ecosystem";
          entry = {
            href = "https://${cfg.url}";
            icon = "plex.svg";
            siteMonitor = "https://${cfg.url}";
          };
        }
      ];

      cloudflared.tunnels."${config.domain.tunnel}".ingress."${cfg.url}" = "http://127.0.0.1:${toString constants.ports.plex}";
    };
  };
}
