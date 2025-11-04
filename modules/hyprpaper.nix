_: {
  flake.modules.homeManager.hyprpaper = {pkgs, ...}: {
    services.hyprpaper.enable = true;
    home.packages = with pkgs; [
      waypaper
      hyprpaper
    ];
  };
}
