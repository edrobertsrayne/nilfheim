{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.jellyfin;
in {
  options.services.jellyfin = {
    url = mkOption {
      type = types.str;
      default = "jellyfin.${config.homelab.domain}";
      description = "URL for Jellyfin proxy.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      jellyfin = {
        dataDir = "/srv/jellyfin";
        openFirewall = true;
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Media";
          name = "Jellyfin";
          entry = {
            href = "https://${cfg.url}";
            icon = "jellyfin.svg";
            siteMonitor = "https://${cfg.url}";
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
    };

    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];

    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
    };

    # Enable intro skipper plugin
    nixpkgs.overlays = with pkgs; [
      (
        final: prev: {
          jellyfin-web = prev.jellyfin-web.overrideAttrs (finalAttrs: previousAttrs: {
            installPhase = ''
              runHook preInstall

              # this is the important line
              sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

              mkdir -p $out/share
              cp -a dist $out/share/jellyfin-web

              runHook postInstall
            '';
          });
        }
      )
    ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver # previously vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
        vpl-gpu-rt # QSV on 11th gen or newer
        intel-media-driver # QSV up to 11th gen
      ];
    };
  };
}
