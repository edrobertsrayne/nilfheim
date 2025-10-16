{lib, ...}:
with lib; {
  options.domain = {
    name = mkOption {
      type = types.str;
      default = "greensroad.uk";
      description = "Base domain for service proxies and DNS.";
    };
    tunnel = mkOption {
      type = types.str;
      description = "Cloudflare tunnel UUID for this host.";
    };
  };
}
