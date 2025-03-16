{
  lib,
  config,
  hostname,
  ...
}:
with lib; let
  cfg = config.modules.hardware.network;
in {
  options.modules.hardware.network = {
    enable = mkEnableOption "Whether to enable networking support.";
  };
  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    networking.hostName = "${hostname}";
  };
}
