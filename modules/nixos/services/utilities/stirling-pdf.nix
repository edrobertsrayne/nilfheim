{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.stirling-pdf;
  constants = import ../../../../lib/constants.nix;
in {
  options.services.stirling-pdf = {
    url = mkOption {
      type = types.str;
      default = "stirling-pdf.${config.homelab.domain}";
      description = "URL for Stirling PDF proxy host.";
    };
    port = mkOption {
      type = types.port;
      default = 8081;
      description = "Port for Stirling PDF service to listen on.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      stirling-pdf.environment = {
        INSTALL_BOOK_AND_ADVANCED_HTML_OPS = "true";
        SERVER_PORT = cfg.port;
      };

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          inherit (constants.nginxDefaults) proxyWebsockets;
        };
      };

      # Homepage dashboard integration
      homepage-dashboard.homelabServices = [
        {
          group = "Utilities";
          name = "Stirling PDF";
          entry = {
            href = "https://${cfg.url}";
            icon = "stirling-pdf.svg";
            siteMonitor = "https://${cfg.url}";
            description = "PDF manipulation toolkit";
          };
        }
      ];
    };
  };
}
