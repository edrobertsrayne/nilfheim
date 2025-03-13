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
      desktop = {
        gnome = enabled;
        addons = {
          alacritty = enabled;
          foot = enabled;
          wezterm = enabled;
        };
      };
      hardware = {
        audio = enabled;
      };
    };
    programs.firefox.enable = true;
  };
}
