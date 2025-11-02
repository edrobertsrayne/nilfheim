_: {
  flake.modules.generic.desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      playerctl
      pamixer
      brightnessctl
      nautilus
      sushi
      cliphist
      pavucontrol

      wl-clipboard
      hyprpolkitagent
      hyprpicker
      hyprsunset
      wlr-randr
    ];
  };
}
