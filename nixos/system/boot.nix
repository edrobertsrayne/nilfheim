{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.system.boot;
in {
  options.modules.system.boot = {
    enable = mkEnableOption "Whether to enable system booting.";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
