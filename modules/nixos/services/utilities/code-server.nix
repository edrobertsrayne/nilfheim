{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.code-server;
  url = "code-server.${config.homelab.domain}";
in {
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

      nginx.virtualHosts."${url}" = {
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
            href = "https://${url}";
            icon = "vscode.svg";
            siteMonitor = "https://${url}";
            description = "VS Code in the browser";
          };
        }
      ];
    };
  };
}
