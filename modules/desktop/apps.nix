_: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      processing
      vlc
      arduino-ide
      gimp
      inkscape
      typora
      spotify
      gnome-calculator
    ];
  };
}
