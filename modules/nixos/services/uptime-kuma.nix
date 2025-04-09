{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.uptime-kuma;
in {
  options.services.uptime-kuma = {
    url = mkOpt' types.str "uptime.${config.homelab.domain}";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."${cfg.url}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
        proxyWebsockets = true;
      };
    };

    services.homepage-dashboard.homelabServices = [
      {
        group = "Monitoring";
        name = "Uptime Kuma";
        entry = {
          href = "https://${cfg.url}";
          icon = "uptime-kuma.svg";
          siteMonitor = "https://${cfg.url}";
        };
      }
    ];
  };
}
