{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.sabnzbd;
  port = 8080;
in {
  options.services.sabnzbd = {
    url = mkOption {
      type = types.str;
      default = "sabnzbd.${config.homelab.domain}";
      description = "URL for sabnzbd proxy host.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      homepage-dashboard.homelabServices = [
        {
          group = "Downloads";
          name = "sabnzbd";
          entry = {
            href = "https://${cfg.url}";
            icon = "sabnzbd.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
