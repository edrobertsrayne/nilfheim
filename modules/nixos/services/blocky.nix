{
  config,
  lib,
  ...
}: let
  cfg = config.nixos.services.blocky;
  inherit (lib) mkEnableOption mkIf;
in {
  options.nixos.services.blocky = {
    enable = mkEnableOption "Whether to enable blocky ad blocking servce.";
  };

  config = mkIf cfg.enable {
    services.blocky = {
      enable = true;
      settings = {
        ports.dns = 53;
        upstreams.groups.default = [
          "https://one.one.one.one/dns-query"
        ];
        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = ["1.1.1.1" "1.0.0.1"];
        };
        blocking = {
          blackLists = {
            ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          };
          allowLists = {
            ads = ["https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt"];
          };
          clientGroupsBlock = {
            default = ["ads"];
          };
        };
        caching = {
          minTime = "5m";
          maxTime = "30m";
          prefetching = true;
        };
        prometheus = {
          enable = true;
          path = "/metrics";
        };
      };
    };
  };
}
