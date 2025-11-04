_: {
  flake.modules.homeManager.hyprland = {
    lib,
    config,
    ...
  }: let
    inherit (config.lib.stylix) colors;
  in {
    wayland.windowManager.hyprland.settings = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
        allow_tearing = false;
        resize_on_border = false;
        "col.active_border" = lib.mkForce "rgba(${colors.base0D}ee) rgba(${colors.base0B}ee) 45deg";
      };

      decoration = {
        rounding = 4;
        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
        };
      };

      group = {
        "col.border_active" = lib.mkForce "rgba(${colors.base0D}ee) rgba(${colors.base0B}ee) 45deg";
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear, 0, 0, 1, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1.0"
          "quick, 0.15, 0, 0.12, 1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "workspaces, 0, 0, ease"
          "fadeLayersIn, 1, 1.73, almostLinear"
          "fadeLayersOut, 1, 1.46, almostLinear"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        anr_missed_pings = 3;
      };

      cursor = {
        hide_on_key_press = true;
      };
    };
  };
}
