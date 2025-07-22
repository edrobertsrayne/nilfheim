{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.autobrr;
  port = "7474";
in {
  options.services.autobrr = {
    url = mkOption {
      type = types.str;
      default = "autobrr.${config.homelab.domain}";
      description = "URL for autobrr proxy host.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      autobrr = {
        secretFile = config.age.secrets.autobrr.path;
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Downloads";
          name = "autobrr";
          entry = {
            href = "https://${cfg.url}";
            icon = "autobrr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
  };
}
