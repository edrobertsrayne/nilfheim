{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.services.karakeep;
in {
  options.services.karakeep = {
    url = mkOption {
      type = types.str;
      default = "karakeep.${config.homelab.domain}";
      description = "URL for karakeep proxy.";
    };

    port = mkOption {
      type = types.port;
      default = 3003;
      description = "Port for karakeep web interface.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      karakeep = {
        environmentFile = config.age.secrets.karakeep.path;

        extraEnvironment = {
          PORT = toString cfg.port;
          DISABLE_NEW_RELEASE_CHECK = "true";
          INFERENCE_ENABLE_AUTO_TAGGING = "true";
          INFERENCE_LANG = "english";
          INFERENCE_CONTEXT_LENGTH = "2048";
          INFERENCE_OUTPUT_SCHEMA = "structured";
        };
      };

      # Nginx proxy configuration
      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };

      # Homepage dashboard integration
      homepage-dashboard.homelabServices = [
        {
          group = "Utilities";
          name = "Karakeep";
          entry = {
            href = "https://${cfg.url}";
            icon = "mdi-book-open-page-variant";
            siteMonitor = "https://${cfg.url}";
            description = "AI-powered bookmark and note management";
          };
        }
      ];
    };
  };
}
