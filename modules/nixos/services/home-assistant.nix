{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.home-assistant;
in {
  options.services.home-assistant = {
    url = mkOption {
      type = types.str;
      default = "homeassistant.${config.homelab.domain}";
    };
  };
  config = mkIf cfg.enable {
    services.home-assistant = {
      extraComponents = [
        # Components required to complete the onboarding
        "met"
        "radio_browser"
        # Recommended for fast zlib compression
        # https://www.home-assistant.io/integrations/isal
        "isal"
        "esphome"
        "sonos"
        "hue"
        "jellyfin"
        "nest"
      ];
      configWritable = true;
      config = {
        default_config = {};
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = ["127.0.0.1"];
          # server_host = "127.0.0.1";
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [8123]; # HA web interface
      allowedUDPPorts = [5353]; # mDNS
    };

    services.nginx.virtualHosts."${cfg.url}" = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        proxy_buffering off;
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:8123";
        proxyWebsockets = true;
      };
    };
  };
}
