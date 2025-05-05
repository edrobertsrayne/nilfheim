{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.virtualisation.podman;
in {
  config = mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = false;
      };
    };

    environment.systemPackages = with pkgs; [
      podman-tui
      podman-compose
    ];
  };
}
