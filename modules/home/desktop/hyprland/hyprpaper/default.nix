{
  lib,
  config,
  ...
}: let
  cfg = config.desktop.hyprpaper;
in {
  options.desktop.hyprpaper = {
    enable = lib.mkEnableOption "Whether to enable hyprpaper wallpaper daemon";
  };

  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [
          "~/Pictures/Wallpapers/among-trees-campsite.jpg"
        ];

        wallpaper = [
          ",~/Pictures/Wallpapers/among-trees-campsite.jpg"
        ];
      };
    };
  };
}
