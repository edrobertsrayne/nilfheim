{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  service = "jellyseerr";
  cfg = config.services."${service}";
in {
  options.services."${service}" = {
    url = mkOpt types.str "${service}.${config.homelab.domain}" "URL for ${service} proxy host.";
  };

  config = mkIf cfg.enable {
    modules.system.persist.extraRootDirectories = [
      {
        directory = "/var/lib/private";
        mode = "0700";
      }
    ];

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
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
        };
      };
    };
  };
}
