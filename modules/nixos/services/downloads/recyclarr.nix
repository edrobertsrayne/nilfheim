{config, ...}: let
  cfg = config.services;
in {
  services.recyclarr.configuration = {
    radarr = [
      {
        api_key = cfg.radarr.apikey;
        base_url = "http://localhost:${toString cfg.radarr.settings.server.port}";
        instance_name = "main";
      }
    ];
    sonarr = [
      {
        api_key = cfg.sonarr.apikey;
        base_url = "http://localhost:${toString cfg.sonarr.settings.server.port}";
        instance_name = "main";
      }
    ];
  };
}
