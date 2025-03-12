{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.suites.desktop;
in {
  options.${namespace}.suites.desktop = with types; {
    enable = mkEnableOption "Whether to enable desktop configuration.";
  };
  config = mkIf cfg.enable {
    ${namespace} = {
      system.fonts = enabled;
      desktop.gnome = enabled;
      desktop.addons.alacritty = enabled;
      hardware = {
        audio = enabled;
      };
    };
    programs.firefox.enable = true;
  };
}
