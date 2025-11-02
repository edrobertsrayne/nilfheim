_: {
  flake.modules.generic.hyprland = {pkgs, ...}: {
    services.hyprpaper.enable = true;
    home.packages = with pkgs; [
      waypaper
      hyprpaper
    ];
  };
}
