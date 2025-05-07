{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.sabnzbd;
  port = 8080;
in {
  options.services.sabnzbd = {
    url = mkOpt types.str "sabnzbd.${config.homelab.domain}" "URL for sabnzbd proxy host.";
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
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
  };
}
