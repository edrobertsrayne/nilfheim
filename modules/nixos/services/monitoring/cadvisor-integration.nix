{
  config,
  lib,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.services.cadvisor;
in {
  config = mkIf cfg.enable {
    services = {
      # Configure cAdvisor to use our custom port
      cadvisor.port = constants.ports.cadvisor;

      # Nginx reverse proxy
      nginx.virtualHosts."cadvisor.${config.homelab.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString constants.ports.cadvisor}";
          inherit (constants.nginxDefaults) proxyWebsockets;
        };
      };

      # Homepage dashboard integration
      homepage-dashboard.homelabServices = [
        {
          group = constants.serviceGroups.monitoring;
          name = "cAdvisor";
          entry = {
            href = "https://cadvisor.${config.homelab.domain}";
            icon = "cadvisor.svg";
            siteMonitor = "http://127.0.0.1:${toString constants.ports.cadvisor}";
            description = constants.descriptions.cadvisor;
          };
        }
      ];
    };
  };
}
