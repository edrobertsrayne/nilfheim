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
  };
  config = mkIf cfg.enable {
    services = {
      calibre-server = {
        enable = true;
        # libraries = [
        #   "/mnt/media/books"
        # ];
        port = 8090;
        openFirewall = true;
      };

      #   calibre-web = {
      #     listen.ip = "127.0.0.1";
      #     dataDir = "/srv/calibre";
      #     group = "tank";
      #     openFirewall = true;
      #     options = {
      #       calibreLibrary = "/mnt/media/books";
      #       enableBookUploading = true;
      #       enableBookConversion = true;
      #     };
      #   };
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
      #   nginx.virtualHosts."${cfg.url}" = {
      #     enableACME = true;
      #     forceSSL = true;
      #     locations."/" = {
      #       proxyPass = "http://127.0.0.1:${toString cfg.listen.port}";
      #     };
      #   };
    };
  };
}
