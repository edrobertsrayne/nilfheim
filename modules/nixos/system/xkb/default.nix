{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.system.xkb;
in {
  options.${namespace}.system.xkb = {
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
