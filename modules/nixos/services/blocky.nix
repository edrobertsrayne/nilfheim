{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.nixos.services.blocky;
in {
  options.nixos.services."blocky" = with types; {
    enable = mkEnableOption "Whether to enable blocky.";
    httpPort = mkOpt int 4000 "Port to serve prometheus metrics on.";
  };

  config = mkIf cfg.enable {
    services.blocky = {
      enable = true;
      settings = {
        ports.dns = 53;
        ports.http = cfg.httpPort;
        upstreams.groups.default = [
          "https://one.one.one.one/dns-query"
        ];
        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = ["1.1.1.1" "1.0.0.1"];
        };
        caching = {
          minTime = "5m";
          maxTime = "30m";
          prefetching = true;
        };
        blocking = {
          blackLists = {
            ads = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            ];
          };
          whiteLists = {
            ads = [
              "https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt"
            ];
          };
        };
        clientGroupsBlock = {
          default = ["ads"];
        };
        prometheus = {
          enable = true;
          path = "/metrics";
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [53 4000];
      allowedUDPPorts = [53];
    };

    services.prometheus.scrapeConfigs = [
      {
        job_name = "blocky";
        static_configs = [{targets = ["127.0.0.1:${builtins.toString cfg.port}"];}];
      }
    ];
  };
}
