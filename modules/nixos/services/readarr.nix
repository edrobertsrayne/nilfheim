{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  service = "readarr";
  cfg = config.services."${service}";
  inherit (cfg.settings.server) port;
in {
  options.services."${service}" = {
    url = mkOpt types.str "${service}.${config.homelab.domain}" "URL for ${service} proxy host.";
    port = mkOpt types.port 8787 "Port to serve ${service} on.";
  };

  config = mkIf cfg.enable {
    services = {
      "${service}" = {
        dataDir = "/srv/${service}";
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Readarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "readarr.svg";
            siteMonitor = "https://${cfg.url}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
  };
}
