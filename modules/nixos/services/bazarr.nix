{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.bazarr;
in {
  options.services.bazarr = {
    url = mkOpt types.str "bazarr.${config.homelab.domain}" "URL for bazarr proxy host.";
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
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
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.listenPort}";
        };
      };
    };
  };
}
