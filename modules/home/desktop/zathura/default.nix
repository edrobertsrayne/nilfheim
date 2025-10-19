{
  lib,
  config,
  ...
}: let
  cfg = config.desktop.zathura;
in {
  options.desktop.zathura = {
    enable = lib.mkEnableOption "Whether to enable zathura PDF viewer";
  };

  config = lib.mkIf cfg.enable {
    # Zathura PDF viewer configuration
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        adjust-open = "best-fit";
        pages-per-row = 1;
        scroll-page-aware = "true";
        scroll-full-overlap = 0.01;
        scroll-step = 50;
        zoom-min = 10;
        guioptions = "none";
        font = "Noto Sans Nerd Font 12";
      };
    };
  };
}
