{
  config,
  lib,
  pkgs,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.services.transmission;
in {
  options.services.transmission = with types; {
    url = mkOption {
      type = str;
      default = "transmission.${config.homelab.domain}";
      description = "URL for transmission proxy.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["tank"];

    systemd.tmpfiles.rules = [
      "d ${cfg.settings.incomplete-dir} 0755 ${cfg.user} tank -"
    ];

    services = {
      transmission = {
        home = mkDefault "/srv/transmission";
        package = pkgs.transmission_4;
        settings = {
          rpc-bind-address = "127.0.0.1";
          rpc-port = 9091;
          peer-port = 51413;
          rpc-whitelist-enabled = false;
          rpc-host-whitelist-enabled = false;

          download-dir = "/mnt/downloads";
          incomplete-dir = "/mnt/downloads/incomplete";

          ratio-limit-enabled = true;
          ratio-limit = 2.0;
          seed-queue-enabled = true;
          seed-queue-size = 5;

          download-queue-enabled = true;
          download-queue-size = 10;
          queue-stalled-enabled = true;
          queue-stalled-minutes = 30;

          cache-size-mb = 16;
          prefetch-enabled = true;

          dht-enabled = true;
          lpd-enabled = false;
          pex-enabled = true;
          utp-enabled = true;

          alt-speed-enabled = false;

          blocklist-enabled = false;
        };
      };

      nginx.virtualHosts."${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.settings.rpc-port}";
          inherit (constants.nginxDefaults) proxyWebsockets;
        };
      };

      homepage-dashboard.homelabServices = [
        {
          group = "Downloads";
          name = "Transmission";
          entry = {
            href = "https://${cfg.url}";
            icon = "transmission.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.settings.rpc-port}";
            description = "Lightweight BitTorrent client";
            widget = {
              type = "transmission";
              url = "http://127.0.0.1:${toString cfg.settings.rpc-port}";
            };
          };
        }
      ];
    };
  };
}
