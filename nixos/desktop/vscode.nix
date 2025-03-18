{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.desktop.vscode;
in {
  options.modules.desktop.vscode = {
    enable = mkEnableOption "Whether to enable VSCode.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.vscode];
  };
}
