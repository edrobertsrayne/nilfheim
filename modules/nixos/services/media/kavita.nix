{
  config,
  lib,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.services.kavita;
in {
  options.services.kavita = {
    url = mkOption {
      type = types.str;
      default = "kavita.${config.homelab.domain}";
      description = "URL for kavita proxy host.";
    };
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
            description = "Digital library for comics and ebooks";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.settings.Port}";
          inherit (constants.nginxDefaults) proxyWebsockets;
        };
      };
    };
  };
}
