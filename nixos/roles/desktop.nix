{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.roles.desktop;
in {
  options.roles.desktop.enable = mkEnableOption "Whether to enable desktop role.";

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    };
    modules = {
      hardware.audio = enabled;
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
