{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.virtualisation.tdarr;
in {
  options.virtualisation.tdarr = with lib.types; {
    enable = mkEnableOption "Whether to enable tdarr server.";
    serverPort = mkOpt int 8266 "Port for the tdarr server.";
    webUIPort = mkOpt int 8265 "Port to serve the tdarr web UI from.";
    nodeName = mkOpt str "InternalNode" "Name for internal node.";
    enableVAAPI = mkBoolOpt true "Use Intel VAAPI for transcoding.";
    dataDir = mkOpt path "/srv/tdarr" "The directory where tdarr will create files.";
    mediaDir = mkOpt path "/mnt/media" "The directory where media for transcoding is stored.";
    cacheDir = mkOpt path "/transcode_cache" "The data where transcoding data is cached.";
    url = mkOpt' str "tdarr.${config.homelab.domain}";
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
