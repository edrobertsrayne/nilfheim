{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.audiobookshelf;
  constants = import ../../../../lib/constants.nix;
in {
  options.services.audiobookshelf = {
    url = mkOption {
      type = types.str;
      default = "audiobookshelf.${config.homelab.domain}";
      description = "URL for audiobookshelf proxy host.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "audiobookshelf";
          entry = {
            href = "https://${cfg.url}";
            icon = "audiobookshelf.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.port}";
            description = "Audiobook and podcast server";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          inherit (constants.nginxDefaults) proxyWebsockets;
        };
      };
    };
  };
}
