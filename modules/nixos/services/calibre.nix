{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.calibre;
in {
  options.services.calibre = {
    enable = mkEnableOption "Whether to enable calibre ebook server.";
    url = mkOpt types.str "calibre.${config.homelab.domain}" "Proxy address for calibre web server.";
  };
  config = mkIf cfg.enable {
    services = {
      calibre-server = {
        enable = true;
        group = "tank";
        libraries = [
          "/mnt/media/calibre"
        ];
        port = 8090;
      };

      calibre-web = {
        enable = true;
        group = "tank";
        listen.ip = "0.0.0.0";
        dataDir = "/srv/calibre";
        options = {
          calibreLibrary = "/mnt/media/calibre";
          enableBookUploading = true;
          enableBookConversion = true;
        };
      };
      #
      #   homepage-dashboard.homelabServices = [
      #     {
      #       group = "Media";
      #       name = "Calibre";
      #       entry = {
      #         href = "https://${cfg.url}";
      #         icon = "calibre.svg";
      #         siteMonitor = "http://127.0.0.1:${toString cfg.listen.port}";
      #       };
      #     }
      #   ];
      #
      nginx.virtualHosts."${cfg.url}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.calibre-web.listen.port}";
        };
      };
    };
  };
}
