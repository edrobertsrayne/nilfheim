{
  pkgs,
  config,
  lib,
  options,
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
      system.fonts.enable = true;
      desktop.gnome.enable = true;
      hardware = {
        audio.enable = true;
      };
    };
    programs.firefox.enable = true;
  };
}
