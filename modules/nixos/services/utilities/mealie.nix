{
  config,
  lib,
  nilfheim,
  ...
}:
with lib; let
  cfg = config.services.mealie;
in {
  options.services.mealie = {
    url = mkOption {
      type = types.str;
      default = nilfheim.helpers.mkServiceUrl "mealie" config.homelab.domain;
      description = "URL for Mealie proxy.";
    };
  };

  config = mkIf cfg.enable {
    services.mealie = {
      port = nilfheim.constants.ports.mealie;
      database.createLocally = true;
      settings = {
        BASE_URL = "https://${cfg.url}";
        # Enable production mode
        PRODUCTION = "true";
        # Optional: Configure default credentials
        DEFAULT_EMAIL = "admin@${config.homelab.domain}";
        DEFAULT_GROUP = "Home";
        # Disable signup (can be enabled later via admin panel)
        ALLOW_SIGNUP = "false";
      };
    };

    # Homepage dashboard integration
    services.homepage-dashboard.homelabServices = [
      {
        group = "Utilities";
        name = "Mealie";
        entry = {
          href = "https://${cfg.url}";
          icon = "mealie.svg";
          siteMonitor = "http://127.0.0.1:${toString nilfheim.constants.ports.mealie}";
          description = nilfheim.constants.descriptions.mealie;
        };
      }
    ];

    # Nginx proxy configuration
    services.nginx.virtualHosts."${cfg.url}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString nilfheim.constants.ports.mealie}";
        inherit (nilfheim.constants.nginxDefaults) proxyWebsockets;
      };
    };

    # Note: /var/lib/mealie is managed by systemd StateDirectory, not persistence
  };
}