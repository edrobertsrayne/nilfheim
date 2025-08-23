_: {
  # Hyprland autostart configuration
  wayland.windowManager.hyprland.settings = {
    # Autostart applications (swaync, hyprpaper, hypridle handled by home-manager services)
    exec-once = [
      "waybar"
      "nm-applet --indicator"
      "hyprpolkitagent"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ];
  };
}
