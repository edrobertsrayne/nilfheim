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
  imports = [];

  options.desktop.hyprland = with types; {
    enable = mkEnableOption "Whether to enable the Hyprland window manager.";
    darkMode = mkOption {
      type = bool;
      default = true;
      description = "Whether to prefer dark mode.";
    };
  };

  config = mkIf cfg.enable {
    desktop = {
      xkb.enable = true;
      gtk.enable = true;
      fonts.enable = true;
    };

    # Enable Hyprland
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    # Display manager handled by workstation role (GDM shared between desktops)

    # Audio
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
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

    # Polkit for authentication
    security.polkit.enable = true;

    # Enable gamemode for gaming
    programs.gamemode.enable = true;

    # Enable Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;

    # System packages for Hyprland ecosystem
    environment.systemPackages = with pkgs; [
      # Core Hyprland utilities
      hyprpaper
      hyprlock
      hypridle
      hyprpicker
      wlogout

      # App launcher
      rofi-wayland

      # Terminal
      foot

      # Browser
      firefox

      # Status bar
      waybar

      # Notifications
      swaynotificationcenter

      # Wallpaper management
      waypaper

      # System utilities
      wl-clipboard
      grim
      slurp
      swappy
      brightnessctl
      playerctl
      pamixer

      # Clipboard management
      cliphist

      # Network management
      networkmanagerapplet

      # System utilities
      pavucontrol
      blueman

      # File manager
      nautilus

      # System monitor
      btop

      # Authentication
      hyprpolkitagent
    ];

    # Home Manager configuration
    home-manager.users.${user.name} = mkMerge [
      (mkIf cfg.enable {
        imports = [
          ./hyprland/config.nix
          ./hyprland/programs.nix
          ./hyprland/services.nix
        ];
      })
      (mkIf cfg.enable {
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
      })
    ];
  };
}
