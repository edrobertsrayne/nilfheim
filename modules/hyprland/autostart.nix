_: {
  flake.modules.home.hyprland = {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "waybar"
        "hyprpolkitagent"
        "waypaper --restore"
      ];
    };
  };
}
