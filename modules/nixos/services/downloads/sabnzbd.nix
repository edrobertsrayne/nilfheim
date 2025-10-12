{
  config,
  lib,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.services.sabnzbd;
in {
  options.services.sabnzbd = {
    url = mkOption {
      type = types.str;
      default = "sabnzbd.${config.domain.name}";
      description = "URL for sabnzbd proxy host.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    services = {
      sabnzbd = {
        configFile = "/var/lib/sabnzbd/sabnzbd.ini";
      };
    };

    # Configure SABnzbd settings
    systemd.services.sabnzbd.preStart = ''
      mkdir -p /var/lib/sabnzbd

      # Update config to listen on all interfaces and set host whitelist
      if [ -f /var/lib/sabnzbd/sabnzbd.ini ]; then
        # Update host to 0.0.0.0 to allow external access
        sed -i 's/^host = .*/host = 0.0.0.0/' /var/lib/sabnzbd/sabnzbd.ini

        # Update host_whitelist
        sed -i 's/^host_whitelist = .*/host_whitelist = sabnzbd.${config.domain.name}, 192.168.68.108, localhost, 127.0.0.1, thor/' /var/lib/sabnzbd/sabnzbd.ini

        # If host_whitelist doesn't exist, add it
        if ! grep -q "^host_whitelist" /var/lib/sabnzbd/sabnzbd.ini; then
          sed -i '/^\[misc\]/a host_whitelist = sabnzbd.${config.domain.name}, 192.168.68.108, localhost, 127.0.0.1, thor' /var/lib/sabnzbd/sabnzbd.ini
        fi

        # Configure download directories
        if grep -q "^\[misc\]" /var/lib/sabnzbd/sabnzbd.ini; then
          sed -i 's|^download_dir = .*|download_dir = /mnt/downloads|' /var/lib/sabnzbd/sabnzbd.ini
          sed -i 's|^complete_dir = .*|complete_dir = /mnt/downloads|' /var/lib/sabnzbd/sabnzbd.ini
          sed -i 's|^incomplete_dir = .*|incomplete_dir = /mnt/downloads/incomplete|' /var/lib/sabnzbd/sabnzbd.ini
        fi
      fi
    '';

    services = {
      homepage-dashboard.homelabServices = [
        {
          group = "Downloads";
          name = "SABnzbd";
          entry = {
            href = "https://${cfg.url}";
            icon = "sabnzbd.svg";
            siteMonitor = "http://127.0.0.1:${toString constants.ports.sabnzbd}";
            description = "Usenet newsgroup downloader";
            # widget = {
            #   type = "sabnzbd";
            #   url = "http://127.0.0.1:${toString constants.ports.sabnzbd}";
            #   key = "{{HOMEPAGE_VAR_SABNZBD_KEY}}";
            # };
          };
        }
      ];

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString constants.ports.sabnzbd}";
          proxyWebsockets = true;
        };
      };
    };

    # Open port for direct IP access on tailscale interface only (for security)
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [constants.ports.sabnzbd];
  };
}
