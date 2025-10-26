_: {
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        ",preferred,auto,1"
      ];
    };
  };
}
