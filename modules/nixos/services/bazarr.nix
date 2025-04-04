{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  service = "bazarr";
  cfg = config.services."${service}";
in {
  options.services."${service}" = {
    url = mkOpt types.str "${service}.${config.homelab.domain}" "URL for ${service} proxy host.";
  };

  config = mkIf cfg.enable {
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
