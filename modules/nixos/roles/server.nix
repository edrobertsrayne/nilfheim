{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.roles.server;
in {
  options.roles.server = {
    enable = mkEnableOption "server role";
  };

  config = mkIf cfg.enable {
    # Auto-enable common role
    roles.common.enable = true;

    services.tailscale.useRoutingFeatures = "server";
    virtualisation = {
      docker.daemon.settings = {
        data-root = "/srv/docker";
      };
      portainer.enable = true;
    };
  };
}
