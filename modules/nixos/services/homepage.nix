{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.homepage-dashboard;
in {
  options.services.homepage-dashboard = {
    url = mkOpt types.str "home.${config.homelab.domain}" "URL for the homepage dashboard proxy.";

    homelabServices = lib.mkOption {
      type = types.listOf dashboardServiceType;
      default = [];
      description = "List of dashboard entries from all services";
    };
  };
  config = mkIf cfg.enable {
    services = {
      homepage-dashboard = let
        groupedAttrs = builtins.groupBy (service: service.group) cfg.homelabServices;
        transformedAttrs =
          lib.mapAttrs (
            group: services: lib.map (service: {"${service.name}" = service.entry;}) services
          )
          groupedAttrs;
        services = lib.mapAttrsToList (group: value: {"${group}" = value;}) transformedAttrs;
      in {
        inherit services;
        customCSS = builtins.readFile ./homepage/custom.css;
        settings = {color = "gray";};
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
            };
          }
          {
            resources = {
              label = "Storage";
              disk = "/";
            };
          }
          {
            openmeteo = {
              label = "Cambridge";
              latitude = 52.2157;
              longitude = 0.1214;
              timezone = "Europe/London";
              units = "metric";
            };
          }
        ];
      };

      nginx.virtualHosts."${cfg.url}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.listenPort}";
        };
      };
    };
  };
}
