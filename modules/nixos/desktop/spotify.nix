{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.spotify;
in {
  options.desktop.spotify = {
    enable = mkEnableOption "Whether to enable Spotify.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.spotify];
    networking.firewall = {
      allowedTCPPorts = [57621];
      allowedUDPPorts = [5353];
    };
  };
}
