{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.stirling-pdf;
in {
  options.services.stirling-pdf = {
    url = mkOption {
      type = types.str;
      default = "stirling-pdf.${config.homelab.domain}";
    };
    port = mkOption {
      type = types.port;
      default = 8081;
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
        };
      };
    };
  };
}
