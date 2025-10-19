{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop.hyprland;
  inherit (config) user;
in {
  options.desktop.hyprland = with types; {
    enable = mkEnableOption "Whether to enable the Hyprland window manager.";
    darkMode = mkOption {
      type = bool;
      default = true;
      description = "Whether to prefer dark mode.";
    };
    keyboardLayout = mkOption {
      type = str;
      default = "gb,us";
      description = "Keyboard layout(s) for Hyprland. Use comma-separated list for multiple layouts.";
    };
  };

  config = mkIf cfg.enable {
    # Enable Hyprland
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    # XDG Desktop Portal
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = ["hyprland" "gtk"];
    };

    # System packages for Hyprland ecosystem
    environment.systemPackages = with pkgs; [
      # Core Hyprland utilities
      hyprpaper
      hyprlock
      hypridle
      hyprpicker
      hyprsunset
      wlogout
      hyprpolkitagent

      # Status bar
      waybar

      # Wallpaper management
      waypaper

      # Wayland utilities
      wl-clipboard
      grim
      slurp
      swappy
    ];

    # Home Manager configuration
    home-manager.users.${user.name} = {
      imports = [
        ../../../home/desktop
      ];

      # Enable Hyprland-specific services
      desktop = {
        hyprlock.enable = true;
        hypridle.enable = true;
        hyprpaper.enable = true;
      };

      # Enable Hyprland window manager
      wayland.windowManager.hyprland.enable = true;

      # Create Screenshots directory
      home.file."Pictures/Screenshots/.keep".text = "";

      # Additional utility programs
      home.packages = with pkgs; [
        # Wallpaper manager
        waypaper

        # Color picker
        hyprpicker

        # Screenshot and clipboard utilities
        wl-clipboard-rs
        grim
        slurp
        swappy
        hyprshot # Hyprland-specific screenshot tool
      ];
    };
  };
}
