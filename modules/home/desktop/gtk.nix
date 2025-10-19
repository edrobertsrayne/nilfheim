{
  config,
  lib,
  osConfig,
  ...
}:
with lib; let
  cfg = config.desktop.gtk;
  # Access system-level gtk config from osConfig
  nixosCfg = osConfig.desktop.gtk;
in {
  options.desktop.gtk = {
    enable = mkEnableOption "Whether to enable GTK home-manager configuration.";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      cursorTheme = {
        inherit (nixosCfg.cursor) name package;
      };
      # iconTheme = {
      #   inherit (nixosCfg.icon) name package;
      # };
    };
  };
}
