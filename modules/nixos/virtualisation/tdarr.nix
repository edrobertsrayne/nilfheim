{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.virtualisation.tdarr;
in {
  options.virtualisation.tdarr = with lib.types; {
    enable = mkEnableOption "Whether to enable tdarr server.";
    serverPort = mkOption {
      type = int;
      default = 8266;
      description = "Port for the tdarr server.";
    };
    webUIPort = mkOption {
      type = int;
      default = 8265;
      description = "Port to serve the tdarr web UI from.";
    };
    nodeName = mkOption {
      type = str;
      default = "InternalNode";
      description = "Name for internal node.";
    };
    enableVAAPI = mkOption {
      type = bool;
      default = true;
      description = "Use; description= Intel VAAPI for transcoding.";
    };
    dataDir = mkOption {
      type = path;
      default = "/srv/tdarr";
      description = "The directory where tdarr will create files.";
    };
    mediaDir = mkOption {
      type = path;
      default = "/mnt/media";
      description = "The directory where media for transcoding is stored.";
    };
    cacheDir = mkOption {
      type = path;
      default = "/transcode_cache";
      description = "The data where transcoding data is cached.";
    };
    url = mkOption {
      type = str;
      default = "tdarr.${config.homelab.domain}";
    };
  };
  config = mkIf cfg.enable {
    virtualisation = {
      podman.enable = true;

      oci-containers.backend = "podman";
      oci-containers.containers."tdarr" = {
        image = "ghcr.io/haveagitgat/tdarr";
        autoStart = true;

        environment = {
          TZ = "Europe/London";
          PUID = "0";
          PGID = "0";
          serverIP = "0.0.0.0";
          serverPort = "${builtins.toString cfg.serverPort}";
          webUIPort = "${builtins.toString cfg.webUIPort}";
          internalNode = "true";
          inContainer = "true";
          ffmpegVersion = "7";
          nodeName = "${cfg.nodeName}";
        };

        ports = [
          "${builtins.toString cfg.serverPort}:${builtins.toString cfg.serverPort}"
          "${builtins.toString cfg.webUIPort}:${builtins.toString cfg.webUIPort}"
        ];

        volumes = [
          "${cfg.dataDir}/server:/app/server"
          "${cfg.dataDir}/configs:/app/configs"
          "${cfg.dataDir}/logs:/app/logs"
          "${cfg.mediaDir}:/media"
          "${cfg.cacheDir}:/temp"
        ];

        extraOptions =
          [
            "--network=bridge"
            "--log-opt=max-size=10m"
            "--log-opt=max-file=5"
          ]
          ++ (
            if cfg.enableVAAPI
            then ["--device=/dev/dri:/dev/dri"]
            else []
          );
      };
    };

    services.nginx.virtualHosts."${cfg.url}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.webUIPort}";
        proxyWebsockets = true;
        extraConfig = ''
          # Cloudflare tunnel compatibility headers
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $host;
          proxy_set_header X-Forwarded-Server $host;

          # WebSocket support headers
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;

          # Proxy timeouts for long-running connections
          proxy_connect_timeout 60s;
          proxy_send_timeout 60s;
          proxy_read_timeout 60s;

          # Buffer settings for better performance
          proxy_buffering off;
          proxy_request_buffering off;

          # Security headers
          add_header X-Frame-Options SAMEORIGIN;
          add_header X-Content-Type-Options nosniff;
          add_header X-XSS-Protection "1; mode=block";
        '';
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}/server 0755 root root"
      "d ${cfg.dataDir}/configs 0755 root root"
      "d ${cfg.dataDir}/logs 0755 root root"
      "d ${cfg.cacheDir} 0755 root root"
    ];
  };
}
