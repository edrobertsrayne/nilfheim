{
  imports = [./common.nix];
  services.tailscale = {
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--ssh"
    ];
  };
  virtualisation.docker.daemon.settings = {
    data-root = "/srv/docker";
  };
}
