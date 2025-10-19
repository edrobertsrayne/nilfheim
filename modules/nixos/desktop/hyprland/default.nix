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
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = ["hyprland" "gtk"];
    };

    environment.systemPackages = with pkgs; [
      hyprpaper
      hyprlock
      hypridle
      hyprpicker
      hyprsunset
      wlogout
      hyprpolkitagent
      waybar
      waypaper

      wl-clipboard
      grim
      slurp
      swappy
    ];

    home-manager.users.${user.name} = {
      imports = [
        ../../../home/desktop
      ];

      desktop = {
        hyprlock.enable = true;
        hypridle.enable = true;
        hyprpaper.enable = true;
      };

      wayland.windowManager.hyprland.enable = true;

      home.file."Pictures/Screenshots/.keep".text = "";

      home.packages = with pkgs; [
        waypaper
        hyprpicker
        wl-clipboard-rs
        grim
        slurp
        swappy
        hyprshot
      ];
    };
  };
}
