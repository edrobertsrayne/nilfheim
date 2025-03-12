{
  config,
  namespace,
  lib,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.addons.alacritty;
in {
  options.${namespace}.desktop.addons.alacritty = {
    enable = mkEnableOption "Whether to enable alacritty terminal emulator";
  };
  config = mkIf cfg.enable {
    ${namespace}.home.extraOptions = {
      programs.alacritty = {
        enable = true;
        settings = {
          font.size = 12;
          font.normal = {
            family = "JetBrains Mono Nerd Font";
            style = "Regular";
          };
          window = {
            opacity = 0.9;
            padding = {
              x = 4;
              y = 0;
            };
          };
        };
      };
    };
  };
}
