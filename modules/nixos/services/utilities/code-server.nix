{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.code-server;
in {
  options.services.code-server = {
    url = mkOption {
      type = types.str;
      default = "code-server.${config.domain.name}";
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

      cloudflared.tunnels."${config.domain.tunnel}".ingress."${cfg.url}" = "http://127.0.0.1:${toString cfg.port}";

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
