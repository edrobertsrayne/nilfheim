{lib, ...}:
with lib;
with lib.custom; {
  options.homelab = {
    domain = mkOpt types.str "greensroad.uk" "Homelab proxy base domain.";
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    services = {
      blocky = enabled;
      grafana = enabled;
      nginx = enabled;
      plex = enabled;
      prometheus = enabled;
    };
  };
}
