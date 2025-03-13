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
    ${namespace}.home = {
      extraOptions = {
        programs.alacritty = {
          enable = true;
          settings = {
            font = {
              size = 12;
              normal = {
                family = "JetBrains Mono Nerd Font";
                style = "Regular";
              };
            };
            window = {
              padding = {
                x = 4;
                y = 0;
              };
              dynamic_padding = true;
            };
            selection.save_to_clipboard = true;
          };
        };
      };
    };
  };
}
