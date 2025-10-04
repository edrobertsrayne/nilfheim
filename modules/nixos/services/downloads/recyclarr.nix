{config, ...}: let
  cfg = config.services;
in {
  services.recyclarr.configuration = {
    radarr = {
      remux-web-1080p = {
        api_key = cfg.radarr.apikey;
        base_url = "http://localhost:${toString cfg.radarr.settings.server.port}";
        include = [
          {template = "radarr-quality-definition-movie";}
          {template = "radarr-quality-profile-remux-web-1080p";}
          {template = "radarr-custom-formats-remux-web-1080p";}
        ];
      };
    };
    sonarr = {
      web-1080p = {
        api_key = cfg.sonarr.apikey;
        base_url = "http://localhost:${toString cfg.sonarr.settings.server.port}";
        include = [
          {template = "sonarr-quality-definition-series";}
          {template = "sonarr-v4-quality-profile-web-1080p";}
          {template = "sonarr-v4-custom-formats-web-1080p";}
        ];
      };
    };
  };
}
