{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.nixos.services.plex;
  inherit (config.nixos.services) caddy;
in {
  options.nixos.services.plex = with types; {
    enable = mkEnableOption "Whether to enable plex.";
    port = mkOption int 32400 "The port to use for plex.";
    subdomain = mkOption str "plex" "The subdomain to use for plex.";
  };

  config = mkIf cfg.enable {
    services = {
      plex = {
        enable = true;
        openFirewall = true;
      };

      caddy.virtualHosts = {
        "${cfg.subdomain}.${caddy.domain}".extraConfig = ''
          reverse_proxy http://127.0.0.1:${cfg.port}
        '';
      };
    };
  };
}
