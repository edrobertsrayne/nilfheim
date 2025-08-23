_: {
  # Core Hyprland window manager configuration
  # This file imports all modular components for better maintainability
  imports = [
    ./keybindings.nix
    ./window-rules.nix
    ./environment.nix
    ./appearance.nix
    ./autostart.nix
  ];

  # Enable Hyprland window manager
  wayland.windowManager.hyprland.enable = true;
}
