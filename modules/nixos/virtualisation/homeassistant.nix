{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.virtualisation.homeassistant;
in {
  options.virtualisation.homeassistant = with lib.types; {
    enable = mkEnableOption "Whether to enable Home Assistant container.";
    configDir = mkOption {
      type = types.path;
      default = "/srv/homeassistant";
    };
    url = mkOption {
      type = types.str;
      default = "homeassistant.${config.homelab.domain}";
    };
  };
  config = mkIf cfg.enable {
    virtualisation = {
      podman.enable = true;
      oci-containers = {
        backend = "podman";
        containers = {
          homeassistant = {
            image = "ghcr.io/home-assistant/home-assistant:stable";
            volumes = [
              "${cfg.configDir}:/config"
            ];
            extraOptions = [
              "--network=host"
            ];
          };
        };
      };
    };

    services.nginx.virtualHosts."${cfg.url}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8123";
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

    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0755 root root"
    ];
  };
}
