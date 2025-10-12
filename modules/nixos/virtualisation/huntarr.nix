{
  lib,
  config,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.virtualisation.huntarr;
in {
  options.virtualisation.huntarr = with lib.types; {
    enable = mkEnableOption "Whether to enable Huntarr container.";
    port = mkOption {
      type = int;
      default = constants.ports.huntarr;
      description = "Port to serve Huntarr from.";
    };
    url = mkOption {
      type = str;
      default = "huntarr.${config.domain.name}";
      description = "URL for the Huntarr web interface.";
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
      oci-containers.containers."huntarr" = {
        image = "huntarr/huntarr:latest";
        autoStart = true;

        environment = {
          TZ = cfg.timezone;
        };

        ports = [
          "${toString cfg.port}:${toString cfg.port}"
        ];

        volumes = [
          "huntarr-config:/config"
        ];

        extraOptions = [
          "--pull=always"
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
        name = "Huntarr";
        entry = {
          href = "https://${cfg.url}";
          icon = "huntarr.svg";
          siteMonitor = "http://127.0.0.1:${toString cfg.port}";
        };
      }
    ];
  };
}
