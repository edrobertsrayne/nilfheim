{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  service = "prowlarr";
  cfg = config.services."${service}";
  inherit (cfg.settings.server) port;
in {
  options.services."${service}" = {
    url = mkOpt types.str "${service}.${config.homelab.domain}" "URL for ${service} proxy host.";
  };

  config = mkIf cfg.enable {
    # TODO: persist Prowlarr storage (currently in /usr/lib/private/prowlarr)

    services = {
      nginx.virtualHosts."${cfg.url}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
  };
}
