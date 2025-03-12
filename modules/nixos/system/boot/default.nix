{
  namespace,
  lib,
  config,
  ...
}:
with lib; with lib.${namespace}; let
  cfg = config.${namespace}.system.boot;
in {
  options.${namespace}.system.boot = {
    enable = mkEnableOption "Whether to enable system boot.";
  };
  config = mkif cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
  };
}
