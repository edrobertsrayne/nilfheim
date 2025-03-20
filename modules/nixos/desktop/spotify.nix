{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.spotify;
in {
  options.modules.desktop.spotify = {
    enable = mkEnableOption "Whether to enable Spotify.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.spotify];
    # modules.system.persist.extraUserDirectories = [];
    networking.firewall = {
      allowedTCPPorts = [57621];
      allowedUDPPorts = [5353];
    };
  };
}
