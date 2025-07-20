{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.lidarr;
  inherit (cfg.settings.server) port;
in {
  options.services.lidarr = {
    url = mkOption {
      type = types.str;
      default = "lidarr.${config.homelab.domain}";
      description = "URL for lidarr proxy host.";
    };
    port = mkOption {
      type = types.port;
      default = 8686;
      description = "Port to serve lidarr on.";
    };
    apikey = mkOption {
      type = types.str;
      default = "f6a4315040e94c7c9eb2aefe5bfc4445";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      lidarr = {
        dataDir = "/srv/lidarr";
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
          inherit (cfg) apikey;
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Lidarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "lidarr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
            widget = {
              type = "lidarr";
              url = "http://127.0.0.1:${toString port}";
              key = "${cfg.apikey}";
            };
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
  };
}
