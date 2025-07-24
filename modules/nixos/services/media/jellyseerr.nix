{
  config,
  lib,
  ...
}:
with lib; let
  service = "jellyseerr";
  cfg = config.services."${service}";
in {
  options.services."${service}" = {
    url = mkOption {
      type = types.str;
      default = "${service}.${config.homelab.domain}";
      description = "URL for ${service} proxy host.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Jellyseerr";
          entry = {
            href = "https://${cfg.url}";
            icon = "jellyseerr.svg";
            siteMonitor = "https://${cfg.url}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
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
