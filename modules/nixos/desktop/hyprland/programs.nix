_: {
  # Home Manager program configurations for Hyprland
  # This file imports all program-specific modules for better maintainability
  imports = [
    ./rofi.nix
    ./waybar.nix
    ./hyprlock.nix
    ./wlogout.nix
    ./zathura.nix
  ];
}
