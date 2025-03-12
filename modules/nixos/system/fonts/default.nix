{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.system.fonts;
in {
  options.${namespace}.system.fonts = with types; {
    enable = mkEnableOption "Whether to install system fonts.";
    fonts = mkOption {
      type = listOf package;
      default = [];
      description = "Custom font packages to install.";
    };
  };
  config = mkIf cfg.enable {
    environment.variables = {
      # Enable log icons because we have nerdfonts.
      LOG_ICONS = "true";
    };
    environment.systemPackages = [pkgs.font-manager];
    fonts.packages = with pkgs;
      [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        nerd-fonts.jetbrains-mono
      ]
      ++ cfg.fonts;
  };
}
