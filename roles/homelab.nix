{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; {
  options.homelab = {
    domain = mkOpt types.str "greensroad.uk" "Homelab proxy base domain.";
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    services = {
      blocky = enabled;
      deluge = enabled;
      grafana = enabled;
      jellyfin = enabled;
      nginx = enabled;
      plex = enabled;
      prometheus = enabled;
      wireguard-netns = {
        enable = true;
        configFile = config.age.secrets.mullvad.path;
        dnsIP = "10.64.0.1";
        privateIP = "10.73.213.60";
      };
    };
  };
}
