{
  config,
  lib,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.services.autobrr;
in {
  options.services.autobrr = {
    url = mkOption {
      type = types.str;
      default = "autobrr.${config.domain.name}";
      description = "URL for autobrr proxy host.";
    };
    port = mkOption {
      type = types.port;
      default = constants.ports.autobrr;
      description = "Port for autobrr service to listen on.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      autobrr = {
        secretFile = config.age.secrets.autobrr.path;
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Downloads";
          name = "autobrr";
          description = "Automated torrent downloading and filtering";
          entry = {
            href = "https://${cfg.url}";
            icon = "autobrr.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.port}";
          };
        }
      ];

      cloudflared.tunnels."${config.domain.tunnel}".ingress."${cfg.url}" = "http://127.0.0.1:${toString cfg.port}";
    };
  };
}
