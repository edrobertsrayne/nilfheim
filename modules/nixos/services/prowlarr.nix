{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  service = "prowlarr";
  cfg = config.services."${service}";
  inherit (cfg.settings.server) port;
in {
  options.services."${service}" = {
    url = mkOpt types.str "${service}.${config.homelab.domain}" "URL for ${service} proxy host.";
  };

  config = mkIf cfg.enable {
    services = {
      prowlarr = {
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
        };
        environmentFiles = [config.age.secrets.servarr.path];
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Downloads";
          name = "Prowlarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "prowlarr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
            widget = {
              type = "prowlarr";
              url = "http://127.0.0.1:${toString port}";
              key = "{{HOMEPAGE_VAR_PROWLARR_APIKEY}}";
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
