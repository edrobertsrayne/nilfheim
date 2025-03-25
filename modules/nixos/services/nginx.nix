{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.nixos.services.nginx;
in {
  options.nixos.services.nginx = {
    enable = mkEnableOption "Whether to enable nginx.";
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
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
