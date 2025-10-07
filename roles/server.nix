{
  imports = [./common.nix];
  services.tailscale.useRoutingFeatures = "server";
  virtualisation.docker.daemon.settings = {
    data-root = "/srv/docker";
  };
}
