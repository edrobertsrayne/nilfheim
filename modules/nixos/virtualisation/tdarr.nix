{
  lib,
  config,
  nilfheim,
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
      docker.enable = true;

      oci-containers.backend = "docker";
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
          # Fix internal node connection
          nodeIP = "127.0.0.1";
          nodePort = "${builtins.toString cfg.serverPort}";
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
            "--health-cmd=curl -f http://localhost:${toString cfg.webUIPort} || exit 1"
            "--health-interval=30s"
            "--health-retries=3"
            "--health-start-period=60s"
            "--dns=1.1.1.1"
            "--dns=8.8.8.8"
            "--dns-search=."
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
