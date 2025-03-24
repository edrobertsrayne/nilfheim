{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.obsidian;
in {
  options.modules.desktop.obsidian = {
    enable = mkEnableOption "Whether to enable Obsidian.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.obsidian];
  };
}
