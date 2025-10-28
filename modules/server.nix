_: {
  flake.modules.nixos.server = {
    services.tailscale.useRoutingFeatures = "server";
    virtualisation = {
      docker.daemon.settings = {
        data-root = "/srv/docker";
      };
    };
  };
}
