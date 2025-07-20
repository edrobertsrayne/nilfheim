{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop.xkb;
in {
  options.desktop.xkb = {
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
