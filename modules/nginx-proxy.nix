{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mapAttrs';
  cfg = config.flake.nilfheim.server.proxy;
  hasServices = cfg.services != {};
in {
  flake.modules.nixos.nginx-proxy = {
    config = mkIf hasServices {
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        virtualHosts = mapAttrs' (name: service:
          lib.nameValuePair service.subdomain {
            locations."/" =
              {
                proxyPass = "http://127.0.0.1:${toString service.port}";
                proxyWebsockets = true;
              }
              // service.extraConfig;
          })
        cfg.services;
      };

      networking.firewall.allowedTCPPorts = [80 443];
    };
  };
}
