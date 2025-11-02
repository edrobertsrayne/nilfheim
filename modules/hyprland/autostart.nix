_: {
  flake.modules.generic.hyprland = {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "waybar"
        "hyprpolkitagent"
        "waypaper --restore"
      ];
    };
  };
}
