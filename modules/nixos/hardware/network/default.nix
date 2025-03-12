{
  lib,
  config,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.hardware.network;
in {
  options.${namespace}.hardware.network = {
    enable = mkEnableOption "Whether to enable networking support.";
  };
  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
