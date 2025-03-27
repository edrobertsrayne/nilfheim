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

        # Convert the attrset into a list of { <group> = [ ... ]; } elements
        services = lib.mapAttrsToList (group: value: {"${group}" = value;}) transformedAttrs;
      in {
        inherit services;
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
