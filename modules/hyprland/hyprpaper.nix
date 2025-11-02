_: {
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    services.hyprpaper.enable = true;
    home.packages = with pkgs; [
      waypaper
      hyprpaper
    ];
  };
}
