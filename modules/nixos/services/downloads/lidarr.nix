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
          proxyWebsockets = true;
          extraConfig = ''
            # Cloudflare tunnel compatibility headers
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;

            # Proxy timeouts for long-running connections
            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;

            # Buffer settings for better performance
            proxy_buffering off;
            proxy_request_buffering off;

            # Security headers
            add_header X-Frame-Options SAMEORIGIN;
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";
          '';
        };
      };
    };
  };
}
