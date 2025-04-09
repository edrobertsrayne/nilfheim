{
  lib,
  config,
  hostname,
  ...
}:
with lib; let
  cfg = config.hardware.network;
in {
  options.hardware.network = {
    enable = mkEnableOption "Whether to enable networking support.";
  };
  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    networking.hostName = "${hostname}";
  };
}
