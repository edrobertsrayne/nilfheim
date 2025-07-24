{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.transmission;
in {
  options.services.transmission = with types; {
    url = mkOption {
      type = str;
      default = "transmission.${config.homelab.domain}";
      description = "URL for transmission proxy.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    systemd.tmpfiles.rules = [
      "d ${cfg.settings.incomplete-dir} 0755 ${cfg.user} tank -"
    ];

    services = {
      transmission = {
        home = mkDefault "/srv/transmission";
        package = pkgs.transmission_4;
        settings = {
          rpc-bind-address = "127.0.0.1";
          rpc-port = 9091;
          peer-port = 51413;
          rpc-whitelist-enabled = false;
          rpc-host-whitelist-enabled = false;

          download-dir = "/mnt/downloads";
          incomplete-dir = "/mnt/downloads/incomplete";

          ratio-limit-enabled = true;
          ratio-limit = 2.0;
          seed-queue-enabled = true;
          seed-queue-size = 5;

          download-queue-enabled = true;
          download-queue-size = 10;
          queue-stalled-enabled = true;
          queue-stalled-minutes = 30;

          cache-size-mb = 16;
          prefetch-enabled = true;

          dht-enabled = true;
          lpd-enabled = false;
          pex-enabled = true;
          utp-enabled = true;

          alt-speed-enabled = false;

          blocklist-enabled = false;
        };
      };

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.settings.rpc-port}";
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

      homepage-dashboard.homelabServices = [
        {
          group = "Downloads";
          name = "Transmission";
          entry = {
            href = "https://${cfg.url}";
            icon = "transmission.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.settings.rpc-port}";
            widget = {
              type = "transmission";
              url = "http://127.0.0.1:${toString cfg.settings.rpc-port}";
            };
          };
        }
      ];
    };
  };
}
