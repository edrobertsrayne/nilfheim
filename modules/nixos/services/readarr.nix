{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.readarr;
  inherit (cfg.settings.server) port;
in {
  options.services.readarr = {
    url = mkOpt types.str "readarr.${config.homelab.domain}" "URL for readarr proxy host.";
    port = mkOpt types.port 8787 "Port to serve readarr on.";
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      readarr = {
        dataDir = "/srv/readarr";
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Readarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "readarr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
            widget = {
              type = "readarr";
              url = "http://127.0.0.1:${toString port}";
              key = "{{HOMEPAGE_VAR_READARR_APIKEY}}";
            };
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
