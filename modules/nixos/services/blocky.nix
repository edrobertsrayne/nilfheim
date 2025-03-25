{
  config,
  lib,
  ...
}: let
  cfg = config.nixos.services.blocky;
  inherit (config.services.blocky.settings) ports;
  inherit (lib) mkEnableOption mkIf;
in {
  options.nixos.services.blocky = {
    enable = mkEnableOption "Whether to enable blocky ad blocking servce.";
  };

  config = mkIf cfg.enable {
    services.blocky = {
      enable = true;
      settings = {
        ports = {
          dns = 53;
          http = 4000;
        };
        upstreams.groups.default = [
          "https://one.one.one.one/dns-query"
        ];
        prometheus = {
          enable = true;
          path = "/metrics";
        };
        caching = {
          minTime = "5m";
          maxTime = "30m";
          prefetching = true;
        };
        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = ["1.1.1.1" "1.0.0.1"];
        };
        blocking = {
          denylists = {
            ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          };
          allowlists = {
            ads = ["https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt"];
          };
          clientGroupsBlock = {
            default = ["ads"];
          };
        };
      };
    };
    networking.firewall = {
      allowedTCPPorts = [ports.dns];
      allowedUDPPorts = [ports.dns];
    };
    services.prometheus.scrapeConfigs = [
      {
        job_name = "blocky";
        static_configs = [
          {
            targets = ["localhost:${toString ports.http}"];
          }
        ];
      }
    ];
  };
}
