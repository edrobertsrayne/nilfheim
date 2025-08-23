_: {
  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration
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
        kb_layout = "us";
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
        border_size = 2;
        layout = "dwindle";
        allow_tearing = false;
      };

      # Decoration
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };

      # Animations
      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layout configuration
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Gestures
      gestures = {
        workspace_swipe = false;
      };

      # Misc settings
      misc = {
        force_default_wallpaper = -1;
      };

      # Window rules
      windowrule = [
        "float,^(rofi)$"
        "float,^(pavucontrol)$"
        "float,^(blueman-manager)$"
        "float,^(nm-connection-editor)$"
        "float,^(file-roller)$"
        "float,^(thunar)$"
        "float,^(cliphist)$"
        "float,^(polkit-gnome-authentication-agent-1)$"
        "float,^(gcr-prompter)$"
        "float,title:^(Picture-in-Picture)$"
        "pin,title:^(Picture-in-Picture)$"
        "opacity 0.85,^(thunar)$"
        "opacity 0.9,^(foot)$"
        "opacity 0.95,^(pavucontrol)$"
        "opacity 0.95,^(blueman-manager)$"
        "size 800 600,^(pavucontrol)$"
        "size 700 500,^(blueman-manager)$"
        "workspace 4,^(discord)$"
        "workspace 4,^(Discord)$"
        "workspace 3,^(vlc)$"
        "workspace 2,^(gimp)$"
        "workspace 2,^(Gimp)$"
        "workspace 2,^(inkscape)$"
        "workspace 2,^(Inkscape)$"
      ];

      # Workspace rules
      workspace = [
        "1, monitor:DP-1, default:true" # General workspace
        "2, monitor:DP-1" # Graphics/Design (GIMP, Inkscape)
        "3, monitor:DP-1" # Media (VLC)
        "4, monitor:DP-1" # Communication (Discord)
        "5, monitor:DP-1" # Additional workspace
      ];

      # Key bindings
      "$mod" = "SUPER";
      bind = [
        # Applications
        "$mod, Return, exec, foot"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating"
        "$mod, R, exec, rofi -show drun"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, F, fullscreen"
        "$mod, L, exec, hyprlock"
        "$mod SHIFT, E, exec, thunar"
        "$mod SHIFT, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

        # System utilities
        "$mod, A, exec, pavucontrol"
        "$mod SHIFT, B, exec, blueman-manager"
        "$mod SHIFT, N, exec, nm-connection-editor"
        "$mod SHIFT, D, exec, discord"

        # Media and graphics
        "$mod SHIFT, V, exec, vlc"
        "$mod SHIFT, G, exec, gimp"
        "$mod SHIFT, I, exec, inkscape"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Screenshots (grim + slurp + swappy)
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mod, Print, exec, grim - | swappy -f -"
        "$mod SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
        "$mod SHIFT, Print, exec, grim ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
        "$mod ALT, Print, exec, grim -g \"$(slurp)\" - | wl-copy"

        # Screenshots (hyprshot - Hyprland optimized)
        "$mod CTRL, Print, exec, hyprshot -m output -o ~/Pictures/Screenshots"
        "$mod CTRL, S, exec, hyprshot -m region -o ~/Pictures/Screenshots"
        "$mod CTRL SHIFT, S, exec, hyprshot -m window -o ~/Pictures/Screenshots"

        # Audio controls
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"

        # Brightness controls
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        # Media controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Autostart
      exec-once = [
        "waybar"
        "swaync"
        "hyprpaper"
        "hypridle"
        "nm-applet --indicator"
        "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];
    };
  };
}
