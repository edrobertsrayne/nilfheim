{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop.fonts;
in {
  options.desktop.fonts = with types; {
    enable = mkEnableOption "Whether to install desktop fonts.";
    fonts = mkOption {
      type = listOf package;
      default = [];
      description = "Custom font packages to install.";
    };
  };
  config = mkIf cfg.enable {
    environment.variables = {
      LOG_ICONS = "true";
    };
    environment.systemPackages = [pkgs.font-manager];
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs;
        [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-emoji
          nerd-fonts.jetbrains-mono
          nerd-fonts.noto
        ]
        ++ cfg.fonts;
      fontconfig = {
        defaultFonts = {
          serif = ["Noto Serif"];
          sansSerif = ["Noto Sans"];
          monospace = ["JetBrainsMono Nerd Font"];
        };
      };
    };
  };
}
