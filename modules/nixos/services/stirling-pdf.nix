{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.stirling-pdf;
in {
  options.services.stirling-pdf = {
    url = mkOpt' types.str "stirling-pdf.${config.homelab.domain}";
    port = mkOpt' types.port 8081;
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
