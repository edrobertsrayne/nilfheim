{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Hyprland window manager home-manager configuration";
    keyboardLayout = mkOption {
      type = types.str;
      default = "gb,us";
      description = "Keyboard layout(s) for Hyprland. Use comma-separated list for multiple layouts.";
    };
  };

  config = mkIf cfg.enable {
    # Enable Hyprland via home-manager
    wayland.windowManager.hyprland.enable = true;

    # Enable Hyprland-related services
    desktop = {
      hyprlock.enable = true;
      hypridle.enable = true;
      hyprpaper.enable = true;
    };

    # Ensure Screenshots directory exists
    home.file."Pictures/Screenshots/.keep".text = "";

    # Hyprland user packages
    home.packages = with pkgs; [
      # Hyprland ecosystem
      hyprpaper
      hyprlock
      hypridle
      hyprpicker
      hyprsunset
      hyprpolkitagent
      wlogout

      # Wayland utilities
      waybar
      waypaper
      wl-clipboard-rs

      # Screenshot tools
      grim
      slurp
      swappy
      hyprshot
    ];
  };
}
