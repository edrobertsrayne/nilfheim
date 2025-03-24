{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.arduino;
in {
  options.modules.desktop.arduino = {
    enable = mkEnableOption "Whether to enable Arduino IDE.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.arduino-ide];
  };
}
