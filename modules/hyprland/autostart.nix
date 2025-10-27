_: {
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "uswm-app -- waybar"
        "hyprpolkitagent"
      ];
    };
  };
}
