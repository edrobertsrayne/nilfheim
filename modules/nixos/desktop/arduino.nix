{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.arduino;
in {
  options.desktop.arduino = {
    enable = mkEnableOption "Whether to enable Arduino IDE.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.arduino-ide];
  };
}
