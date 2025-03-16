{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.roles.desktop;
in {
  options.roles.desktop.enable = mkEnableOption "Whether to enable desktop role.";

  config = mkIf cfg.enable {
    modules = {
      desktop = {
        gnome = enabled;
        foot = enabled;
        firefox = enabled;
      };
      system = {
        fonts = enabled;
        xkb = enabled;
      };
    };
  };
}
