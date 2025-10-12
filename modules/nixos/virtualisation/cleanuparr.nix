{
  lib,
  config,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.virtualisation.cleanuparr;
in {
  options.virtualisation.cleanuparr = with lib.types; {
    enable = mkEnableOption "Whether to enable Cleanuparr container.";
    port = mkOption {
      type = int;
      default = constants.ports.cleanuparr;
      description = "Port to serve Cleanuparr from.";
    };
    url = mkOption {
      type = str;
      default = "cleanuparr.${config.domain.name}";
      description = "URL for the Cleanuparr web interface.";
    };
    timezone = mkOption {
      type = str;
      default = "Europe/London";
      description = "Timezone for the container.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker.enable = true;

      oci-containers.backend = "docker";
      oci-containers.containers."cleanuparr" = {
        image = "ghcr.io/cleanuparr/cleanuparr:latest";
        autoStart = true;

        environment = {
          PORT = "${toString cfg.port}";
          BASE_PATH = "";
          PUID = "1000";
          PGID = "1000";
          UMASK = "022";
          TZ = cfg.timezone;
        };

        ports = [
          "${toString cfg.port}:${toString cfg.port}"
        ];

        volumes = [
          "cleanuparr-config:/config"
        ];
      };
    };

    services.nginx.virtualHosts."${cfg.url}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;
      };
    };

    services.homepage-dashboard.homelabServices = [
      {
        group = "Downloads";
        name = "Cleanuparr";
        entry = {
          href = "https://${cfg.url}";
          icon = "cleanuparr.svg";
          siteMonitor = "http://127.0.0.1:${toString cfg.port}";
        };
      }
    ];
  };
}
