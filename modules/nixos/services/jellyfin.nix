{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.jellyfin;
in {
  options.services.jellyfin = {
    url = mkOpt types.str "jellyfin.${config.homelab.domain}" "URL for Jellyfin proxy.";
  };

  config = mkIf cfg.enable {
    services = {
      jellyfin.dataDir = "/srv/jellyfin";

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
        enableACME = true;
        forceSSL = true;
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

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver # previously vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
        vpl-gpu-rt # QSV on 11th gen or newer
        intel-media-sdk # QSV up to 11th gen
      ];
    };
  };
}
