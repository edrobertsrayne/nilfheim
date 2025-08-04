{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.gtk;
  inherit (config) user;
in {
  options.desktop.gtk = with types; {
    enable = mkEnableOption "Whether to customize GTK and apply themes.";
    cursor = {
      name = mkOption {
        type = str;
        default = "Bibata-Modern-Ice";
        description = "The name of the cursor theme to apply.";
      };
      package = mkOption {
        type = package;
        default = pkgs.bibata-cursors;
        description = "The package to use for the cursor theme.";
      };
    };
    icon = {
      name = mkOption {
        type = str;
        default = "Papirus";
        description = "The name of the icon theme to apply.";
      };
      package = mkOption {
        type = package;
        default = pkgs.papirus-icon-theme;
        description = "The package to use for the icon theme.";
      };
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
        iconTheme = mkDefault {
          inherit (cfg.icon) name package;
        };
      };
    };
  };
}
