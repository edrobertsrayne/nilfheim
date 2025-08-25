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
        initialEmail = config.user.email;
        initialPasswordFile =
          pkgs.writeText "pgadmin_password"
          ''
            password123
          '';
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
          inherit (constants.nginxDefaults) proxyWebsockets extraConfig;
        };
      };
    };
  };
}
