{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.virtualisation.podman;
in {
  config = mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        dockerCompat = false;
        defaultNetwork.settings.dns_enabled = false;
      };
    };

    environment.systemPackages = with pkgs; [
      podman-tui
      podman-compose
    ];
  };
}
