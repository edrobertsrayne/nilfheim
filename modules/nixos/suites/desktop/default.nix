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
      hardware = {
        audio.enable = true;
      };
    };
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb.layout = "gb";
    };

    services.libinput.enable = true;

    programs.firefox.enable = true;
  };
}
