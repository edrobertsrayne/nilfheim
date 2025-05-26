{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
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
      default = "homeassistant.${config.homelab.domain}";
    };
  };
  config = mkIf cfg.enable {
    virtualisation = {
      podman.enable = true;
      oci-containers = {
        backend = "podman";
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
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8123";
        proxyWebsockets = true;
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0755 root root"
    ];
  };
}
