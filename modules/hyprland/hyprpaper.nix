_: {
  flake.modules.home.hyprland = {pkgs, ...}: {
    services.hyprpaper.enable = true;
    home.packages = with pkgs; [
      waypaper
      hyprpaper
    ];
  };
}
