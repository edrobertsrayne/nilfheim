{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.kavita;
in {
  options.services.kavita = {
    url = mkOpt types.str "kavita.${config.homelab.domain}" "URL for kavita proxy host.";
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      kavita = {
        dataDir = "/srv/kavita";
        tokenKeyFile = config.age.secrets.kavita.path;
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "kavita";
          entry = {
            href = "https://${cfg.url}";
            icon = "kavita.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.settings.Port}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.settings.Port}";
        };
      };
    };
  };
}
