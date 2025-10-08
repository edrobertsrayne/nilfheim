{
  lib,
  config,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.services.uptime-kuma;
in {
  options.services.uptime-kuma = {
    url = mkOption {
      type = types.str;
      default = "uptime.${config.homelab.domain}";
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."${cfg.url}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString constants.ports.uptime-kuma}";
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
          description = "Uptime monitoring and alerting";
        };
      }
    ];
  };
}
