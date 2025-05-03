{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.audiobookshelf;
in {
  options.services.audiobookshelf = {
    url = mkOpt types.str "audiobookshelf.${config.homelab.domain}" "URL for audiobookshelf proxy host.";
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
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
