{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.virtualisation.esphome;
in {
  options.virtualisation.esphome = with lib.types; {
    enable = mkEnableOption "Whether to enable ESPHome container.";
    configDir = mkOption {
      type = types.path;
      default = "/srv/esphome";
    };
    url = mkOption {
      type = types.str;
      default = "esphome.${config.homelab.domain}";
    };
  };
  config = mkIf cfg.enable {
    virtualisation = {
      podman.enable = true;
      oci-containers = {
        backend = "podman";
        containers = {
          esphome = {
            image = "ghcr.io/esphome/esphome";
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
        proxyPass = "http://127.0.0.1:6052";
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0755 root root"
    ];
  };
}
