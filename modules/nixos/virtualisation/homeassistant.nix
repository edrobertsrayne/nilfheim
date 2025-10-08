{
  lib,
  config,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.virtualisation.homeassistant;
in {
  options.virtualisation.homeassistant = with lib.types; {
    enable = mkEnableOption "Whether to enable Home Assistant container.";
    configDir = mkOption {
      type = types.path;
      default = "/srv/homeassistant";
    };
    url = mkOption {
      type = types.str;
      default = "homeassistant.${config.domain.name}";
    };
  };
  config = mkIf cfg.enable {
    virtualisation = {
      docker.enable = true;
      oci-containers = {
        backend = "docker";
        containers = {
          homeassistant = {
            image = "ghcr.io/home-assistant/home-assistant:stable";
            volumes = [
              "${cfg.configDir}:/config"
            ];
            extraOptions = [
              "--network=host"
            ];
          };
        };
      };
    };

    services.nginx.virtualHosts."${cfg.url}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString constants.ports.homeassistant}";
        proxyWebsockets = true;
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0755 root root"
    ];
  };
}
