{
  config,
  lib,
  nilfheim,
  ...
}:
with lib; let
  cfg = config.services.code-server;
in {
  options.services.code-server = {
    url = mkOption {
      type = types.str;
      default = "code-server.${config.homelab.domain}";
      description = "URL for code-server proxy host.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      code-server = {
        auth = "none";
        host = "127.0.0.1";
        port = 8443;
        disableTelemetry = true;
        disableUpdateCheck = true;
        disableFileDownloads = false;
      };

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
          name = "Code Server";
          entry = {
            href = "https://${cfg.url}";
            icon = "vscode.svg";
            siteMonitor = "https://${cfg.url}";
            description = "VS Code in the browser";
          };
        }
      ];
    };
  };
}
