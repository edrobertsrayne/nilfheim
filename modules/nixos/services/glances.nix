{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.glances;
in {
  options.services.glances = {
    url = mkOption {
      type = types.str;
      default = "glances.${config.homelab.domain}";
      description = "URL for glances proxy host.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      homepage-dashboard = {
        homelabServices = [
          {
            group = "Monitoring";
            name = "glances";
            entry = {
              href = "https://${cfg.url}";
              icon = "glances.svg";
              siteMonitor = "http://127.0.0.1:${toString cfg.port}";
            };
          }
          {
            group = "Monitoring";
            name = "CPU Usage";
            entry = {
              widget = {
                type = "glances";
                url = "http://127.0.0.1:${toString cfg.port}";
                version = 4;
                metric = "cpu";
              };
            };
          }
          {
            group = "Monitoring";
            name = "Memory Usage";
            entry = {
              widget = {
                type = "glances";
                url = "http://127.0.0.1:${toString cfg.port}";
                version = 4;
                metric = "memory";
              };
            };
          }
          {
            group = "Monitoring";
            name = "Network Usage";
            entry = {
              widget = {
                type = "glances";
                url = "http://127.0.0.1:${toString cfg.port}";
                version = 4;
                metric = "network:eno1";
              };
            };
          }
          {
            group = "Monitoring";
            name = "CPU Temp";
            entry = {
              widget = {
                type = "glances";
                url = "http://127.0.0.1:${toString cfg.port}";
                version = 4;
                metric = "sensor:Package id 0";
              };
            };
          }
          {
            group = "Monitoring";
            name = "/nix";
            entry = {
              widget = {
                type = "glances";
                url = "http://127.0.0.1:${toString cfg.port}";
                version = 4;
                metric = "fs:/nix";
                chart = false;
              };
            };
          }
          {
            group = "Monitoring";
            name = "/mnt/media";
            entry = {
              widget = {
                type = "glances";
                url = "http://127.0.0.1:${toString cfg.port}";
                version = 4;
                metric = "fs:/mnt/media";
                chart = false;
              };
            };
          }
          {
            group = "Monitoring";
            name = "/mnt/downloads";
            entry = {
              widget = {
                type = "glances";
                url = "http://127.0.0.1:${toString cfg.port}";
                version = 4;
                metric = "fs:/mnt/downloads";
                chart = false;
              };
            };
          }
        ];
      };

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
        };
      };
    };
  };
}
