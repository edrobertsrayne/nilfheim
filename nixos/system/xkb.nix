{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.system.xkb;
in {
  options.modules.system.xkb = {
    enable = mkEnableOption "Whether to configure xkb.";
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;

    services.xserver = {
      xkb = {
        layout = "gb";
        options = "caps:escape";
      };
    };
  };
}
