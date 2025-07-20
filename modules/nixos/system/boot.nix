{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.system.boot;
in {
  options.system.boot = {
    enable = mkEnableOption "Whether to enable system booting.";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };
}
