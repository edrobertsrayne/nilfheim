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
      default = nilfheim.helpers.mkServiceUrl "mealie" config.domain.name;
      description = "URL for Mealie proxy.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      mealie = {
        port = nilfheim.constants.ports.mealie;
        database.createLocally = true;
        settings = {
          BASE_URL = "https://${cfg.url}";
          # Enable production mode
          PRODUCTION = "true";
          # Optional: Configure default credentials
          DEFAULT_EMAIL = "admin@${config.domain.name}";
          DEFAULT_GROUP = "Home";
          # Disable signup (can be enabled later via admin panel)
          ALLOW_SIGNUP = "false";
        };
      };

      # Homepage dashboard integration
      homepage-dashboard.homelabServices = [
        {
          group = "Utilities";
          name = "Mealie";
          entry = {
            href = "https://${cfg.url}";
            icon = "mealie.svg";
            siteMonitor = "http://127.0.0.1:${toString nilfheim.constants.ports.mealie}";
            description = "Recipe manager and meal planner";
          };
        }
      ];

      # Cloudflare tunnel ingress
      cloudflared.tunnels."${config.domain.tunnel}".ingress."${cfg.url}" = "http://127.0.0.1:${toString nilfheim.constants.ports.mealie}";
    };

    # Note: /var/lib/mealie is managed by systemd StateDirectory, not persistence
  };
}
