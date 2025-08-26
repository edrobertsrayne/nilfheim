{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.your-spotify;
  constants = import ../../../../lib/constants.nix;
in {
  options.services.your-spotify = {
    enable = mkEnableOption "Your Spotify analytics dashboard";

    url = mkOption {
      type = types.str;
      default = "spotify.${config.homelab.domain}";
      description = "URL for Your Spotify proxy host";
    };

    port = mkOption {
      type = types.port;
      default = constants.ports.your-spotify;
      description = "Port for Your Spotify web interface";
    };

    dataFolder = mkOption {
      type = types.str;
      default = "${constants.paths.dataDir}/your-spotify";
      description = "Directory to store Your Spotify data";
    };

    user = mkOption {
      type = types.str;
      default = "your-spotify";
      description = "User account under which Your Spotify runs";
    };

    group = mkOption {
      type = types.str;
      default = "your-spotify";
      description = "Group under which Your Spotify runs";
    };

    clientId = mkOption {
      type = types.str;
      default = "";
      description = "Spotify API client ID";
    };

    clientSecret = mkOption {
      type = types.str;
      default = "";
      description = "Spotify API client secret";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open firewall for Your Spotify";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      home = cfg.dataFolder;
      createHome = true;
    };

    users.groups.${cfg.group} = {};

    systemd.services.your-spotify = {
      description = "Your Spotify analytics dashboard";
      wantedBy = ["multi-user.target"];
      after = ["network.target" "postgresql.service"];
      wants = ["postgresql.service"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = "5s";
        WorkingDirectory = cfg.dataFolder;

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

        ExecStart = "${pkgs.your_spotify}/bin/your_spotify --port ${toString cfg.port}";
      };

      environment = {
        PORT = toString cfg.port;
        CLIENT_ENDPOINT = "https://${cfg.url}";
        SERVER_ENDPOINT = "https://${cfg.url}/api";
        SPOTIFY_PUBLIC = cfg.clientId;
        SPOTIFY_SECRET = cfg.clientSecret;
        CORS = "https://${cfg.url}";
        MONGO_ENDPOINT = "mongodb://127.0.0.1:27017/yourspotify";
        API_ENDPOINT = "https://${cfg.url}/api";
      };
    };

    services = {
      # MongoDB for Your Spotify data
      mongodb = {
        enable = true;
        bind_ip = "127.0.0.1";
        extraConfig = ''
          storage:
            dbPath: ${constants.paths.dataDir}/mongodb
        '';
      };

      # Homepage integration
      homepage-dashboard.homelabServices = [
        {
          group = constants.serviceGroups.utilities;
          name = "Your Spotify";
          entry = {
            href = "https://${cfg.url}";
            icon = "spotify.svg";
            siteMonitor = "http://127.0.0.1:${toString cfg.port}";
            description = constants.descriptions.your-spotify;
          };
        }
      ];

      # Nginx reverse proxy
      nginx.virtualHosts."${cfg.url}" = {
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

        locations."/api" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}/api";
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
    };

    # Firewall
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [cfg.port];

    # Ensure data directory exists
    systemd.tmpfiles.rules = [
      "d '${cfg.dataFolder}' 0755 ${cfg.user} ${cfg.group} - -"
    ];
  };
}
