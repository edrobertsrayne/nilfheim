{
  config,
  lib,
  ...
}: let
  inherit (config.lib.stylix) colors;
  cfg = config.desktop.walker;
in {
  options.desktop.walker = {
    enable = lib.mkEnableOption "Whether to enable walker application launcher";
  };

  config = lib.mkIf cfg.enable {
    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        theme = "nilfheim";
        force_keyboard_focus = true;
        close_when_open = true;
        disable_mouse = false;
        click_to_close = true;
        global_argument_delimiter = "#";
        exact_search_prefix = "'";
      };
      themes = {
        "nilfheim" = {
          style =
            ''
              @define-color selected-text ${colors.withHashtag.base06};
              @define-color text ${colors.withHashtag.base05};
              @define-color base ${colors.withHashtag.base00};
              @define-color border ${colors.withHashtag.base0D};
              @define-color foreground ${colors.withHashtag.base05};
              @define-color background ${colors.withHashtag.base00};
            ''
            + builtins.readFile ./style.css;
        };
      };
    };
  };
}
