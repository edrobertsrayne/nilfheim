{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.nixos.services.caddy;
in {
  options.nixos.services.caddy = {
    enable = mkEnableOption "Whether to enable caddy reverse proxy service.";
    domain = mkOpt str "greensroad.uk" "Base domain for reverse proxy.";
  };

  config = mkIf cfg.enable {
    services.caddy = enabled;
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
