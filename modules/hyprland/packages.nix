_: {
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
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

      processing
      vlc
      arduino-ide
      gimp
      inkscape
      typora
      gnome-calculator
    ];
  };
}
