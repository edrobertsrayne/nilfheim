{lib, ...}:
with lib;
with lib.custom; {
  options.homelab = {
    domain = mkOpt types.str "greensroad.uk" "Homelab proxy base domain.";
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    virtualisation = {
      # esphome.enable = true;
      homeassistant.enable = true;
      podman.enable = true;
      tdarr.enable = true;
    };

    services = {
      audiobookshelf.enable = true;
      bazarr.enable = true;
      blocky.enable = true;
      deluge.enable = true;
      glances.enable = true;
      grafana.enable = true;
      homepage-dashboard.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
      kavita.enable = true;
      lidarr.enable = true;
      nginx.enable = true;
      prometheus.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      # sabnzbd.enable = true;
      sonarr.enable = true;
      stirling-pdf.enable = true;
      tailscale = {
        useRoutingFeatures = "server";
        extraUpFlags = [
          ''--exit-node 10.71.91.83''
          ''--exit-node-allow-lan-access''
          ''--advertise-routes "192.168.68.0/24"''
        ];
      };
      uptime-kuma.enable = true;
    };

    system.persist.extraRootDirectories = [
      {
        directory = "/var/lib/private";
        mode = "0700";
      }
    ];
  };
}
