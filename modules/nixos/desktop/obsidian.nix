{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.obsidian;
in {
  options.desktop.obsidian = {
    enable = mkEnableOption "Whether to enable Obsidian.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.obsidian];
  };
}
