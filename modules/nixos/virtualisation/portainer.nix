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

    dataDir = mkOption {
      type = types.path;
      default = "/srv/portainer";
      description = "Directory where Portainer stores its data";
    };

    url = mkOption {
      type = types.str;
      default = "portainer.${config.homelab.domain}";
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
            "${cfg.dataDir}:/data"
            "/var/run/docker.sock:/var/run/docker.sock"
          ];

          extraOptions = [
            "--pull=always"
          ];
        };
      };
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts."${cfg.url}" = {
      locations."/" = {
        proxyPass = "https://127.0.0.1:${toString constants.ports.portainer}";
        extraConfig = ''
          proxy_ssl_verify off;
        '';
        proxyWebsockets = true;
      };
    };

    # Create data directory
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 root root -"
    ];

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
