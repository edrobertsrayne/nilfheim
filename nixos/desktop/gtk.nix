{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.desktop.gtk;
  inherit (config.modules) user;
in {
  options.modules.desktop.gtk = with types; {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
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
    home-manager.users.${user.name} = {
      gtk = {
        enable = true;
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
