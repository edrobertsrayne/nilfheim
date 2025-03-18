{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.roles.desktop;
in {
  options.roles.desktop.enable = mkEnableOption "Whether to enable desktop role.";

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    stylix = {
      enable = true;
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    };
    modules = {
      hardware.audio = enabled;
      desktop = {
        arduino = enabled;
        gnome = enabled;
        foot = enabled;
        firefox = enabled;
        obsidian = enabled;
        vscode = enabled;
      };
      system = {
        fonts = enabled;
        xkb = enabled;
      };
    };
  };
}
