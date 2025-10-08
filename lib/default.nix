{lib, ...}: let
  constants = import ./constants.nix;
in {
  # Re-export all our libraries with consistent interface
  inherit constants;
  services = import ./services.nix {inherit lib;};

  # Add convenience helpers that work across modules
  helpers = {
    # Standard service URL pattern
    mkServiceUrl = serviceName: domain: "${serviceName}.${domain}";

    # Get service category for homepage grouping
    getServiceCategory = serviceName:
      if builtins.elem serviceName ["plex" "jellyfin" "jellyseerr" "audiobookshelf" "kavita"]
      then "Media"
      else if builtins.elem serviceName ["sonarr" "radarr" "lidarr" "bazarr" "prowlarr"]
      then "Downloads"
      else if builtins.elem serviceName ["transmission" "deluge" "sabnzbd" "autobrr"]
      then "Downloads"
      else if builtins.elem serviceName ["prometheus" "grafana" "alertmanager" "uptime-kuma" "loki" "promtail" "glances"]
      then "Monitoring"
      else if builtins.elem serviceName ["homepage" "n8n" "code-server" "stirling-pdf" "karakeep"]
      then "Utilities"
      else "Utilities";

    # Standard service description lookup
    getServiceDescription = serviceName:
      constants.descriptions.${serviceName} or "Service: ${serviceName}";
  };

  # Library metadata
  version = "1.0.0";
}
