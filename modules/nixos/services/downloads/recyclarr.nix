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
          {template = "sonarr-v4-custom-formats-web-1080p";}
        ];
        quality_profiles = [
          {
            name = "WEB-1080p";
            upgrade = {
              allowed = true;
              until_quality = "WEB-DL-1080p";
            };
            qualities = [
              {
                name = "WEB-DL-1080p";
                qualities = ["WEBDL-1080p" "WEBRip-1080p"];
              }
              {name = "Bluray-1080p";}
              {name = "HDTV-1080p";}
              {
                name = "WEB-DL-720p";
                qualities = ["WEBDL-720p" "WEBRip-720p"];
              }
              {name = "Bluray-720p";}
              {name = "HDTV-720p";}
            ];
          }
        ];
      };
    };
  };
}
