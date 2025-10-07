{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.cadvisor;
  constants = import ../../../../lib/constants.nix;
in {
  config = mkIf cfg.enable {
    # Configure cAdvisor to use our custom port
    services.cadvisor.port = constants.ports.cadvisor;

    # Nginx reverse proxy
    services.nginx.virtualHosts."cadvisor.${config.homelab.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString constants.ports.cadvisor}";
        inherit (constants.nginxDefaults) proxyWebsockets;
      };
    };

    # Homepage dashboard integration
    services.homepage-dashboard.homelabServices = [{
      group = constants.serviceGroups.monitoring;
      name = "cAdvisor";
      entry = {
        href = "https://cadvisor.${config.homelab.domain}";
        icon = "cadvisor.svg";
        siteMonitor = "http://127.0.0.1:${toString constants.ports.cadvisor}";
        description = constants.descriptions.cadvisor;
      };
    }];
  };
}
