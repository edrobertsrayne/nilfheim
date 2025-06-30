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

    virtualisation = {
      # esphome.enable = true;
      # homeassistant.enable = true;
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
      home-assistant = {
        enable = true;
        extraComponents = [
          # Components required to complete the onboarding
          "analytics"
          "google_translate"
          "met"
          "radio_browser"
          "shopping_list"
          # Recommended for fast zlib compression
          # https://www.home-assistant.io/integrations/isal
          "isal"
          "esphome"
          "sonos"
          "hue"
          "jellyfin"
          "nest"
        ];
        config = {
          # Includes dependencies for a basic setup
          # https://www.home-assistant.io/integrations/default_config/
          default_config = {};
          http = {
            use_x_forwarded_for = true;
            trusted_proxies = ["127.0.0.1"];
          };

          automation = "!include automations.yaml";
          script = "!include scripts.yaml";
          scene = "!include scenes.yaml";
        };
      };
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

    system.persist.extraRootDirectories = [
      {
        directory = "/var/lib/private";
        mode = "0700";
      }
    ];
  };
}
