{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.audiobookshelf;
in {
  options.services.audiobookshelf = {
    url = mkOption {
      type = types.str;
      default = "audiobookshelf.${config.domain.name}";
      description = "URL for audiobookshelf proxy host.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "audiobookshelf";
          entry = {
            href = "https://${cfg.url}";
            icon = "audiobookshelf.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.port}";
            description = "Audiobook and podcast server";
          };
        }
      ];

      cloudflared.tunnels."${config.domain.tunnel}".ingress."${cfg.url}" = "http://127.0.0.1:${toString cfg.port}";
    };
  };
}
