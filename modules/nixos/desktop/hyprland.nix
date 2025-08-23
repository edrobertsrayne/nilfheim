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
    };

    # Display manager
    services.displayManager = {
      ly = {
        enable = true;
      };
    };

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
      ];
    };

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

      # File manager
      nautilus

      # System monitor
      btop
    ];

    # Home Manager configuration
    home-manager.users.${user.name} = {
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
            "col.active_border" = "rgba(89b4faff) rgba(cba6f7ff) 45deg";
            "col.inactive_border" = "rgba(313244aa)";
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
            "col.shadow" = "rgba(1a1a1aee)";
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
            "float,^(nm-connection-editor)$"
            "float,^(file-roller)$"
          ];

          # Workspace rules
          workspace = [
            "1, monitor:DP-1, default:true"
            "2, monitor:DP-1"
            "3, monitor:DP-1"
            "4, monitor:DP-1"
            "5, monitor:DP-1"
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

            # Screenshot
            ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
            "$mod, Print, exec, grim - | swappy -f -"

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
          ];
        };
      };

      # Programs configuration will be added in separate commits
    };
  };
}
