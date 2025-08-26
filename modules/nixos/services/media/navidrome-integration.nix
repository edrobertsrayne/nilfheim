{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.navidrome;
  constants = import ../../../../lib/constants.nix;
  enabled = cfg.enable;
in {
  # This module provides additional integration for the built-in Navidrome service
  config = mkIf enabled {
    services = {
      # Override default port to match our constants
      navidrome = {
        settings = {
          Port = constants.ports.navidrome;
          Address = "127.0.0.1";
        };
      };

      # Homepage integration
      homepage-dashboard.homelabServices = [
        {
          group = constants.serviceGroups.media;
          name = "Navidrome";
          entry = {
            href = "https://navidrome.${config.homelab.domain}";
            icon = "navidrome.svg";
            siteMonitor = "http://127.0.0.1:${toString constants.ports.navidrome}";
            description = constants.descriptions.navidrome;
          };
        }
      ];

      # Nginx reverse proxy
      nginx.virtualHosts."navidrome.${config.homelab.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString constants.ports.navidrome}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_buffering off;
          '';
        };
      };
    };

    # Ensure the navidrome user has access to media groups
    users.users.navidrome.extraGroups = constants.userGroups;
  };
}
