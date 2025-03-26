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
    };
    security.acme = {
      acceptTerms = true;
      defaults.email = "ed.rayne@gmail.com";
    };
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
