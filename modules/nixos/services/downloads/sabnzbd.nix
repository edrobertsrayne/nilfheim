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

    system.persist.extraRootDirectories = [
      {
        directory = "/var/lib/sabnzbd";
        inherit (cfg) user group;
        mode = "0750";
      }
    ];

    systemd.services.sabnzbd.preStart = ''
      if [ -f /var/lib/sabnzbd/sabnzbd.ini ]; then
        # Only update host_whitelist if it doesn't include our domain
        if ! grep -q "${cfg.url}" /var/lib/sabnzbd/sabnzbd.ini; then
          sed -i "s/^host_whitelist = \(.*\)$/host_whitelist = \1, ${cfg.url}/" /var/lib/sabnzbd/sabnzbd.ini
        fi
      fi
    '';

    services = {
      sabnzbd = {
        openFirewall = true;
      };

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
          extraConfig = ''
            proxy_set_header X-Forwarded-Host $host;
          '';
        };
      };
    };
  };
}
