{
  lib,
  config,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.virtualisation.portainer;
in {
  options.virtualisation.portainer = {
    enable = mkEnableOption "Portainer container management interface";

    url = mkOption {
      type = types.str;
      default = "portainer.${config.domain.name}";
      description = "URL for accessing Portainer web interface";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker.enable = true;

      oci-containers = {
        backend = "docker";
        containers.portainer = {
          image = "portainer/portainer-ce:latest";
          autoStart = true;

          ports = [
            "${toString constants.ports.portainer}:9443"
            "${toString constants.ports.portainer-http}:9000"
            "${toString constants.ports.portainer-agent}:8000"
          ];

          volumes = [
            "portainer_data:/data"
            "/var/run/docker.sock:/var/run/docker.sock"
          ];

          extraOptions = [
            "--pull=always"
          ];
        };
      };
    };

    # Cloudflare tunnel ingress
    services.cloudflared.tunnels."${config.domain.tunnel}".ingress."${cfg.url}" = "https://127.0.0.1:${toString constants.ports.portainer}";

    # Homepage dashboard integration
    services.homepage-dashboard.homelabServices = [
      {
        group = "Monitoring";
        name = "Portainer";
        entry = {
          href = "https://${cfg.url}";
          icon = "portainer.svg";
          siteMonitor = "https://127.0.0.1:${toString constants.ports.portainer}";
          description = "Docker container management web interface";
        };
      }
    ];
  };
}
