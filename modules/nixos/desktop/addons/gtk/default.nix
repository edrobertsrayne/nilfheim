{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.addons.gtk;
  inherit (config.${namespace}) user;
in {
  options.${namespace}.desktop.addons.gtk = with types; {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
    theme = {
      name = mkOpt str "Nordic-darker" "The name of the GTK theme to apply.";
      package = mkOpt package pkgs.nordic "The package to use for the theme.";
    };
    cursor = {
      name = mkOpt str "Bibata-Modern-Ice" "The name of the cursor theme to apply.";
      package = mkOpt package pkgs.bibata-cursors "The package to use for the cursor theme.";
    };
    icon = {
      name = mkOpt str "Papirus" "The name of the icon theme to apply.";
      package = mkOpt package pkgs.papirus-icon-theme "The package to use for the icon theme.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.icon.package
      cfg.cursor.package
    ];

    environment.sessionVariables = {
      XCURSOR_THEME = cfg.cursor.name;
    };
    snowfallorg.users.${user.name}.home.config = {
      gtk = {
        enable = true;
        theme = {
          inherit (cfg.theme) name package;
        };
        cursorTheme = {
          inherit (cfg.cursor) name package;
        };
        iconTheme = {
          inherit (cfg.icon) name package;
        };
      };
    };
  };
}
