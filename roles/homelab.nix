{
  lib,
  config,
  inputs,
  system,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.homelab;
in {
  options.homelab = {
    domain = mkOpt types.str "greensroad.uk" "Homelab proxy base domain.";
    tunnel = mkOption {
      type = types.str;
      default = "23c4423f-ec30-423b-ba18-ba18904ddb85";
    };
  };

  config = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      inputs.proxmox-nixos.overlays.${system}
    ];

    virtualisation = {
      homeassistant.enable = true;
      podman.enable = true;
      tdarr.enable = true;
    };

    services = {
      audiobookshelf.enable = true;
      bazarr.enable = true;
      blocky.enable = true;
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
      deluge.enable = true;
      flaresolverr.enable = true;
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
      proxmox-ve = {
        enable = true;
        ipAddress = "192.168.68.122";
      };
      radarr.enable = true;
      readarr.enable = true;
      # sabnzbd.enable = true;
      sonarr.enable = true;
      stirling-pdf.enable = true;
      tailscale = {
        useRoutingFeatures = "server";
        extraUpFlags = [
          "--exit-node 10.71.91.83"
          "--exit-node-allow-lan-access=true"
          ''--advertise-routes "192.168.68.0/24"''
        ];
        extraSetFlags = [
          "--exit-node-allow-lan-access=true"
        ];
      };
      uptime-kuma.enable = true;
    };

    # systemd.services.cloudflared.restartIfChanged = false;

    system.persist.extraRootDirectories = [
      {
        directory = "/var/lib/private";
        mode = "0700";
      }
    ];
  };
}
