{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.deluge;
  inherit (config.services.wireguard-netns) namespace;
in {
  options.services.deluge = with types; {
    url = mkOpt types.str "deluge.${config.homelab.domain}" "URL for deluge proxy.";
  };

  config = mkIf cfg.enable {
    services = {
      deluge = {
        web.enable = true;
        dataDir = mkDefault "/srv/deluge";
        declarative = true;
        authFile = "${pkgs.writeText "deluge-auth" ''
          localclient:deluge:10
        ''}";
      };

      nginx.virtualHosts."${cfg.url}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.web.port}";
          proxyWebsockets = true;
        };
      };

      prometheus = {
        exporters.deluge = {
          enable = true;
          delugePasswordFile = "${pkgs.writeText "deluge-exporter" ''
            deluge
          ''}";
        };
        scrapeConfigs = [
          {
            job_name = "deluge-exporter";
            static_configs = [
              {
                targets = ["localhost:${toString config.services.prometheus.exporters.deluge.port}"];
              }
            ];
          }
        ];
      };

      grafana.provision.dashboards.settings.providers = [
        {
          name = "Deluge";
          options.path = ./grafana/deluge.json;
        }
      ];
    };

    systemd = lib.mkIf config.services.wireguard-netns.enable {
      services = {
        deluged = {
          bindsTo = ["netns@${namespace}.service"];
          requires = [
            "network-online.target"
            "${namespace}.service"
          ];
          serviceConfig.NetworkNamespacePath = ["/var/run/netns/${namespace}"];
        };
        "deluged-proxy" = {
          enable = true;
          description = "Proxy to Deluge Daemon in Network Namespace";
          requires = [
            "deluged.service"
            "deluged-proxy.socket"
          ];
          after = [
            "deluged.service"
            "deluged-proxy.socket"
          ];
          unitConfig = {
            JoinsNamespaceOf = "deluged.service";
          };
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:58846";
            PrivateNetwork = "yes";
          };
        };
      };
      sockets."deluged-proxy" = {
        enable = true;
        description = "Socket for Proxy to Deluge WebUI";
        listenStreams = ["58846"];
        wantedBy = ["sockets.target"];
      };
    };
  };
}
