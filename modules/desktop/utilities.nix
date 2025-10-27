_: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      playerctl
      pamixer
      brightnessctl
      nautilus
      cliphist
      pavucontrol
    ];
  };
}
