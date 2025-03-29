{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; {
  options.homelab = {
    domain = mkOpt types.str "greensroad.uk" "Homelab proxy base domain.";
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    services = {
      bazarr = enabled;
      blocky = enabled;
      deluge = enabled;
      grafana = enabled;
      homepage-dashboard = enabled;
      jellyfin = enabled;
      jellyseerr = enabled;
      lidarr = enabled;
      nginx = enabled;
      plex = enabled;
      prometheus = enabled;
      prowlarr = enabled;
      radarr = enabled;
      readarr = enabled;
      sonarr = enabled;
      wireguard-netns = {
        enable = true;
        configFile = config.age.secrets.mullvad.path;
        dnsIP = "10.64.0.1";
        privateIP = "10.73.213.60";
      };
    };
  };
}
