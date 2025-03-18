{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.roles.laptop;
in {
  options.roles.laptop = {
    enable = mkEnableOption "Whether to enable the laptop role.";
  };

  config = mkIf cfg.enable {
    powerManagement = enabled;
  };
}
