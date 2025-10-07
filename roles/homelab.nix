{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.homelab;
in {
  imports = [./server.nix];

  options.homelab = {
    domain = mkOption {
      type = types.str;
      default = "greensroad.uk";
      description = "Homelab proxy base domain.";
    };
    tunnel = mkOption {
      type = types.str;
      default = "23c4423f-ec30-423b-ba18-ba18904ddb85";
    };
    ip = mkOption {
      default = "192.168.68.122";
      type = types.str;
    };
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    virtualisation = {
      homeassistant.enable = true;
      portainer.enable = false; # Will enable after migrating containers to Docker
      tdarr.enable = true;
    };

    services = {
      audiobookshelf.enable = true;
      backup.restic = {
        enable = true;
        repository = "/mnt/backup/thor/restic";
      };
      bazarr.enable = true;
      blocky.enable = true;
      code-server.enable = true;
      cloudflared = {
        enable = true;
        tunnels."${cfg.tunnel}" = {
          credentialsFile = config.age.secrets.cloudflare-homelab.path;
          default = "http_status:404";
          ingress = {
            "*.${cfg.domain}" = "http://localhost:80";
          };
        };
      };
      deluge.enable = false;
      flaresolverr.enable = true;
      glances.enable = true;
      grafana.enable = true;
      homepage-dashboard.enable = true;
      loki.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
      karakeep.enable = true;
      kavita.enable = true;
      lidarr.enable = true;
      mealie.enable = true;
      n8n.enable = true;
      nginx.enable = true;
      pgadmin.enable = true;
      postgresql.enable = true;
      prometheus = {
        enable = true;
        alertmanager.enable = true;
      };
      promtail.enable = true;
      service-health.enable = true;
      smartctl-exporter.enable = true;
      zfs-exporter.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      recyclarr.enable = true;
      sabnzbd.enable = false;
      sonarr.enable = true;
      stirling-pdf.enable = true;
      tailscale = {
        extraUpFlags = [
          "--exit-node 10.71.91.83"
          "--exit-node-allow-lan-access=true"
          ''--advertise-routes "192.168.68.0/24"''
        ];
        extraSetFlags = [
          "--exit-node-allow-lan-access=true"
        ];
      };
      transmission.enable = true;
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
