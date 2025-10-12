{config, ...}: let
  cfg = config.services;
in {
  services.recyclarr.configuration = {
    radarr = {
      hd-bluray-web = {
        api_key = cfg.radarr.apikey;
        base_url = "http://localhost:${toString cfg.radarr.settings.server.port}";
        include = [
          {template = "radarr-quality-definition-movie";}
          {template = "radarr-quality-profile-hd-bluray-web";}
          {template = "radarr-custom-formats-hd-bluray-web";}
        ];
      };
    };
    sonarr = {
      web-1080p = {
        api_key = cfg.sonarr.apikey;
        base_url = "http://localhost:${toString cfg.sonarr.settings.server.port}";
        include = [
          {template = "sonarr-quality-definition-series";}
          {template = "sonarr-v4-quality-profile-web-1080p-alternative";}
          {template = "sonarr-v4-custom-formats-web-1080p";}
        ];
      };
    };
  };
}
