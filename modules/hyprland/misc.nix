_: {
  flake.modules.homeManager.hyprland = { ...}: let
  in {
    # Hyprland environment and system configuration
    wayland.windowManager.hyprland.settings = {
      monitor = [
        ",preferred,auto,1"
      ];

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "MOZ_WEBRENDER,1"
        "NIXOS_OZONE_WL,1"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      # Input configuration
      input = {
        kb_layout = keyboardLayout;
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = false;
        };
        sensitivity = 0;
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        layout = "dwindle";
        allow_tearing = false;
      };

      # Dwindle layout settings
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Master layout settings
      master = {
        new_status = "master";
      };

      # Miscellaneous settings
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };
    };
  };
}
