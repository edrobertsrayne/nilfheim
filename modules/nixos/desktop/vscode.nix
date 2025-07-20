{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.vscode;
in {
  options.desktop.vscode = {
    enable = mkEnableOption "Whether to enable VSCode.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.vscode];
  };
}
