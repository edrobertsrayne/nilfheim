{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.homepage-dashboard;

  dashboardServiceType = types.submodule {
    options = {
      group = mkOption {type = types.str;};
      name = mkOption {type = types.str;};
      entry = mkOption {type = types.attrs;};
    };
  };
in {
  options.services.homepage-dashboard = {
    url = mkOption {
      type = types.str;
      default = "home.${config.homelab.domain}";
      description = "URL for the homepage dashboard proxy.";
    };
    homelabServices = mkOption {
      type = types.listOf dashboardServiceType;
      default = [];
      description = "List of dashboard entries from all services";
    };
  };
  config = mkIf cfg.enable {
    services = {
      homepage-dashboard = let
        services = lib.mapAttrsToList (group: services: {
          "${group}" = lib.map (service: {"${service.name}" = service.entry;}) services;
        }) (builtins.groupBy (service: service.group) cfg.homelabServices);
      in {
        inherit services;
        customCSS = builtins.readFile ./homepage/custom.css;
        settings = {
          color = "gray";
          headerStyle = "clean";
          hideVersion = true;
          language = "en";
          quicklaunch = {
            searchDescriptions = true;
            hideInternetSearch = true;
          };
        };
        environmentFile = config.age.secrets.homepage.path;
        widgets = [
          {
            resources = {
              label = "System";
              cpu = true;
              memory = true;
              cputemp = true;
              uptime = true;
              units = "metric";
              refresh = 1000;
            };
          }
          {
            resources = {
              label = "Storage";
              disk = ["/" "/mnt/media"];
              units = "metric";
            };
          }
          {
            openmeteo = {
              label = "Cambridge";
              latitude = 52.2157;
              longitude = 0.1214;
              timezone = "Europe/London";
              units = "metric";
              cache = 5;
            };
          }
        ];
      };

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.listenPort}";
          proxyWebsockets = true;
          extraConfig = ''
            # Cloudflare tunnel compatibility headers
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;

            # Proxy timeouts for long-running connections
            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;

            # Buffer settings for better performance
            proxy_buffering off;
            proxy_request_buffering off;

            # Custom security headers for homepage
            add_header X-Frame-Options DENY;
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";
            add_header Referrer-Policy strict-origin-when-cross-origin;
          '';
        };
        locations."~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$" = {
          proxyPass = "http://127.0.0.1:${toString cfg.listenPort}";
          extraConfig = ''
            expires 1h;
            add_header Cache-Control "public, immutable";
          '';
        };
      };
    };
  };
}
