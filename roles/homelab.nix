{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  # List of service users that need access to tank datasets
  tankServiceUsers = [
    "radarr"
    "lidarr"
    "plex"
    "sonarr"
    "jellyfin"
    "deluge"
  ];
in {
  options.homelab = {
    domain = mkOpt types.str "greensroad.uk" "Homelab proxy base domain.";
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    services = {
      autobrr.enable = true;
      bazarr.enable = true;
      blocky.enable = true;
      deluge.enable = true;
      glances.enable = true;
      grafana.enable = true;
      homepage-dashboard.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
      lidarr.enable = true;
      nginx.enable = true;
      plex.enable = true;
      prometheus.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      sonarr.enable = true;
      tailscale = {
        useRoutingFeatures = "server";
        extraUpFlags = [
          "--advertise-exit-node"
          ''--advertise-routes "192.168.68.0/24"''
        ];
      };
      uptime-kuma.enable = true;
      wireguard-netns = {
        enable = true;
        configFile = config.age.secrets.mullvad.path;
        dnsIP = "10.64.0.1";
        privateIP = "10.73.213.60";
      };
    };

    # TODO: Move jellyseerr and prowlarr data into /srv
    system.persist.extraRootDirectories = [
      {
        directory = "/var/lib/private";
        mode = "0700";
      }
    ];

    # Give services that need it access to the tank datapool
    users.users = lib.mkMerge (
      map
      (user: {
        ${user}.extraGroups = ["tank"];
      })
      tankServiceUsers
    );
  };
}
