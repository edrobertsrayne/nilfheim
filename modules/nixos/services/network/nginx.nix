{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.nginx;
in {
  config = mkIf cfg.enable {
    services.nginx = {
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # WebSocket upgrade support - map for connection upgrade handling
      appendHttpConfig = ''
        map $http_upgrade $connection_upgrade {
          default upgrade;
          "" close;
        }

        # Global security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
      '';

      # Match all server names not caught by other virtualHosts
      virtualHosts."_" = {
        default = true;
        locations."/" = {
          return = "444"; # Close connection without response
        };
      };
    };
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
