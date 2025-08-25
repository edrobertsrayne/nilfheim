{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.pgadmin;
  constants = import ../../../../lib/constants.nix;
in {
  options.services.pgadmin = {
    url = mkOption {
      type = types.str;
      default = "pgadmin.${config.homelab.domain}";
      description = "URL for pgAdmin proxy.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      # Configure the built-in pgAdmin service
      pgadmin = {
        port = constants.ports.pgadmin;
        initialEmail = "admin@${config.homelab.domain}";
        initialPasswordFile = pkgs.writeText "pgadmin-password" "admin123";
      };

      # Homepage integration
      homepage-dashboard.homelabServices = [
        {
          group = "Data";
          name = "pgAdmin";
          entry = {
            href = "https://${cfg.url}";
            icon = "postgresql.svg";
            siteMonitor = "http://127.0.0.1:${toString constants.ports.pgadmin}";
            description = "PostgreSQL administration interface";
          };
        }
      ];

      # Nginx proxy using recommended defaults
      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString constants.ports.pgadmin}";
          inherit (constants.nginxDefaults) proxyWebsockets;
          extraConfig = constants.nginxDefaults.extraConfig + ''
            # pgAdmin specific settings
            proxy_set_header X-Script-Name /;
            proxy_set_header X-Scheme $scheme;
            proxy_redirect http://$host/ https://$host/;
            proxy_redirect http://$host:${toString constants.ports.pgadmin}/ https://$host/;
            proxy_cookie_domain localhost $host;
            proxy_cookie_path / /;
          '';
        };
      };
    };
  };
}
