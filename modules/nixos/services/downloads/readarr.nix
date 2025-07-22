{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.readarr;
  inherit (cfg.settings.server) port;
in {
  options.services.readarr = {
    url = mkOption {
      type = types.str;
      default = "readarr.${config.homelab.domain}";
      description = "URL for readarr proxy host.";
    };
    port = mkOption {
      type = types.port;
      default = 8787;
      description = "Port to serve readarr on.";
    };
    apikey = mkOption {
      type = types.str;
      default = "8fdde8ce0f444f80bb6c8626b97f2598";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      readarr = {
        dataDir = "/srv/readarr";
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
          inherit (cfg) apikey;
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Readarr";
          entry = {
            href = "https://${cfg.url}";
            icon = "readarr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
            widget = {
              type = "readarr";
              url = "http://127.0.0.1:${toString port}";
              key = "${cfg.apikey}";
            };
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
