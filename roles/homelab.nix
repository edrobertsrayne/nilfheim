{lib, ...}:
with lib;
with lib.custom; {
  options.homelab = {
    domain = mkOpt types.str "greensroad.uk" "Homelab proxy base domain.";
  };

  config = {
    nixos.services = {
      blocky = enabled;
      grafana = enabled;
      nginx = enabled;
      prometheus = enabled;
    };
  };
}
