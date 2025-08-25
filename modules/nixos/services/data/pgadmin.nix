{
  config,
  lib,
  ...
}:
with lib; let
  constants = import ../../../../lib/constants.nix;
  inherit (config) homelab;
in {
  config = mkIf config.services.pgadmin.enable {
    services = {
      # Configure the built-in pgAdmin service
      pgadmin = {
        port = constants.ports.pgadmin;
        initialEmail = "admin@${homelab.domain}";
        initialPasswordFile = config.age.secrets.pgadmin-password.path;
      };

      # Homepage integration
      homepage-dashboard.homelabServices = [
        {
          group = "Data";
          name = "pgAdmin";
          entry = {
            href = "https://pgadmin.${homelab.domain}";
            icon = "postgresql.svg";
            siteMonitor = "http://127.0.0.1:${toString constants.ports.pgadmin}";
            description = "PostgreSQL administration interface";
          };
        }
      ];

      # Nginx proxy
      nginx.virtualHosts."pgadmin.${homelab.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString constants.ports.pgadmin}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Script-Name /;
            proxy_set_header X-Scheme $scheme;
            proxy_redirect off;
          '';
        };
      };
    };
  };
}
