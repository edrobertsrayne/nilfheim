{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.navidrome;
  constants = import ../../../../lib/constants.nix;
in {
  options.services.navidrome = {
    enable = mkEnableOption "Navidrome music server";

    url = mkOption {
      type = types.str;
      default = "navidrome.${config.homelab.domain}";
      description = "URL for Navidrome proxy host";
    };

    port = mkOption {
      type = types.port;
      default = constants.ports.navidrome;
      description = "Port for Navidrome web interface";
    };

    musicFolder = mkOption {
      type = types.str;
      default = constants.paths.music;
      description = "Path to music library";
    };

    dataFolder = mkOption {
      type = types.str;
      default = "${constants.paths.dataDir}/navidrome";
      description = "Directory to store Navidrome data";
    };

    user = mkOption {
      type = types.str;
      default = "navidrome";
      description = "User account under which Navidrome runs";
    };

    group = mkOption {
      type = types.str;
      default = "navidrome";
      description = "Group under which Navidrome runs";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open firewall for Navidrome";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      home = cfg.dataFolder;
      createHome = true;
      extraGroups = constants.userGroups;
    };

    users.groups.${cfg.group} = {};

    systemd.services.navidrome = {
      description = "Navidrome music server";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = "5s";

        # Security hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        # Directory access
        ReadWritePaths = [cfg.dataFolder];
        ReadOnlyPaths = [cfg.musicFolder];

        ExecStart = "${pkgs.navidrome}/bin/navidrome --musicfolder ${cfg.musicFolder} --datafolder ${cfg.dataFolder} --port ${toString cfg.port}";
      };

      environment = {
        ND_MUSICFOLDER = cfg.musicFolder;
        ND_DATAFOLDER = cfg.dataFolder;
        ND_PORT = toString cfg.port;
        ND_ADDRESS = "127.0.0.1";
        ND_LOGLEVEL = "info";
        ND_SCANSCHEDULE = "1h";
        ND_SESSIONTIMEOUT = "24h";
        ND_ENABLETRANSCODINGCONFIG = "true";
        ND_ENABLEDOWNLOADS = "true";
        ND_ENABLESHARING = "true";
      };
    };

    # Homepage integration
    services.homepage-dashboard.homelabServices = [
      {
        group = constants.serviceGroups.media;
        name = "Navidrome";
        entry = {
          href = "https://${cfg.url}";
          icon = "navidrome.svg";
          siteMonitor = "http://127.0.0.1:${toString cfg.port}";
          description = constants.descriptions.navidrome;
        };
      }
    ];

    # Nginx reverse proxy
    services.nginx.virtualHosts."${cfg.url}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_buffering off;
        '';
      };
    };

    # Firewall
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [cfg.port];

    # Ensure music directory exists
    systemd.tmpfiles.rules = [
      "d '${cfg.dataFolder}' 0755 ${cfg.user} ${cfg.group} - -"
    ];
  };
}
