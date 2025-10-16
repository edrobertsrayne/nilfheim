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

      # Cloudflare tunnel ingress
      cloudflared.tunnels."${config.domain.tunnel}".ingress."cadvisor.${config.domain.name}" = "http://127.0.0.1:${toString constants.ports.cadvisor}";

      # Homepage dashboard integration
      homepage-dashboard.homelabServices = [
        {
          group = "Monitoring";
          name = "cAdvisor";
          entry = {
            href = "https://cadvisor.${config.domain.name}";
            icon = "cadvisor.svg";
            siteMonitor = "http://127.0.0.1:${toString constants.ports.cadvisor}";
            description = "Container resource usage and performance analysis";
          };
        }
      ];
    };
  };
}
