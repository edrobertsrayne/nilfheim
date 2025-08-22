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
