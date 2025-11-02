_: {
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "waybar"
        "hyprpolkitagent"
        "waypaper --restore"
      ];
    };
  };
}
