{
  config,
  lib,
  ...
}: let
  inherit (config) homelab;
  cfg = config.nixos.services.grafana;
in {
  options.nixos.services.grafana = {
    enable = lib.mkEnableOption {
      description = "Enable grafana";
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/srv/grafana";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "grafana.${homelab.domain}";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 3000;
    };
  };
  config = lib.mkIf cfg.enable {
    services.grafana = {
      enable = true;
      inherit (cfg) dataDir;
      settings = {
        server = {
          domain = "${cfg.url}";
          http_port = cfg.port;
          http_addr = "127.0.0.1";
        };
      };
      provision.enable = true;
    };

    services.nginx.virtualHosts."${cfg.url}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
      };
    };
  };
}
