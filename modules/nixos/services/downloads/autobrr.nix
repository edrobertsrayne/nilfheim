{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.autobrr;
  port = "7474";
in {
  options.services.autobrr = {
    url = mkOption {
      type = types.str;
      default = "autobrr.${config.homelab.domain}";
      description = "URL for autobrr proxy host.";
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
          entry = {
            href = "https://${cfg.url}";
            icon = "autobrr.svg";
            siteMonitor = "http://127.0.0.1:${toString port}";
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

            # WebSocket support headers
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;

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
