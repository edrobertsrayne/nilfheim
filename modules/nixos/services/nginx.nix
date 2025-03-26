{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.nginx;
in {
  config = mkIf cfg.enable {
    services.nginx = {
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # Match all server names not caught by other virtualHosts
      virtualHosts."_" = {
        default = true;
        locations."/" = {
          return = "444"; # Close connection without response
        };
      };
    };
    security.acme = {
      acceptTerms = true;
      defaults.email = "ed.rayne@gmail.com";
    };
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
