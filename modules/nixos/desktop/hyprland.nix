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

    # Display manager handled by GNOME module when both are enabled

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
      xfce.thunar

      # System monitor
      btop

      # Communication
      discord

      # Document viewer
      zathura

      # Authentication
      polkit_gnome
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
            "$mod SHIFT, E, exec, thunar"
            "$mod SHIFT, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

            # System utilities
            "$mod, A, exec, pavucontrol"
            "$mod SHIFT, B, exec, blueman-manager"
            "$mod SHIFT, N, exec, nm-connection-editor"
            "$mod SHIFT, D, exec, discord"

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

      # Program configurations
      programs = {
        # Rofi configuration
        rofi = {
          enable = true;
          package = pkgs.rofi-wayland;
          terminal = "foot";
          font = "JetBrainsMono Nerd Font 14";
          extraConfig = {
            modi = "drun,run";
            icon-theme = "Papirus";
            show-icons = true;
            drun-display-format = "{icon} {name}";
            disable-history = false;
            hide-scrollbar = true;
            display-drun = " Apps ";
            display-run = " Run ";
            sidebar-mode = true;
          };
        };

        # Waybar configuration
        waybar = {
          enable = true;
          settings = {
            mainBar = {
              layer = "top";
              position = "top";
              height = 32;
              spacing = 4;

              modules-left = ["hyprland/workspaces" "hyprland/mode"];
              modules-center = ["hyprland/window"];
              modules-right = ["tray" "pulseaudio" "network" "battery" "clock"];

              # Workspaces configuration
              "hyprland/workspaces" = {
                disable-scroll = true;
                all-outputs = true;
                format = "{icon}";
                format-icons = {
                  "1" = "1";
                  "2" = "2";
                  "3" = "3";
                  "4" = "4";
                  "5" = "5";
                  default = "";
                };
              };

              # Window title
              "hyprland/window" = {
                format = "{class}";
                separate-outputs = true;
                max-length = 50;
              };

              # System tray
              tray = {
                spacing = 10;
              };

              # Audio
              pulseaudio = {
                format = "{volume}% {icon}";
                format-bluetooth = "{volume}% {icon}";
                format-bluetooth-muted = " {icon}";
                format-muted = "";
                format-icons = {
                  headphone = "";
                  hands-free = "";
                  headset = "";
                  phone = "";
                  portable = "";
                  car = "";
                  default = ["" "" ""];
                };
                on-click = "pavucontrol";
              };

              # Network
              network = {
                format-wifi = "{essid} ";
                format-ethernet = "{ipaddr}/{cidr} ";
                tooltip-format = "{ifname} via {gwaddr} ";
                format-linked = "{ifname} (No IP) ";
                format-disconnected = "Disconnected ⚠";
                format-alt = "{ifname}: {ipaddr}/{cidr}";
                on-click-right = "nm-connection-editor";
              };

              # Battery
              battery = {
                states = {
                  warning = 30;
                  critical = 15;
                };
                format = "{capacity}% {icon}";
                format-charging = "{capacity}% ";
                format-plugged = "{capacity}% ";
                format-alt = "{time} {icon}";
                format-icons = ["" "" "" "" ""];
              };

              # Clock
              clock = {
                tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                format = "{:%a %b %d  %I:%M %p}";
                format-alt = "{:%Y-%m-%d}";
              };
            };
          };

          style = ''
            * {
              border: none;
              border-radius: 0;
              font-family: "JetBrainsMono Nerd Font";
              font-weight: bold;
              font-size: 13px;
              min-height: 0;
            }

            window#waybar {
              background-color: transparent;
              border-bottom: 3px solid transparent;
              transition-property: background-color;
              transition-duration: 0.5s;
            }

            button {
              box-shadow: inset 0 -3px transparent;
              border: none;
              border-radius: 0;
            }

            #workspaces button {
              padding: 0 8px;
              background-color: transparent;
            }

            #workspaces button:hover {
              box-shadow: inherit;
            }

            #workspaces button.active {
              background-color: rgba(255, 255, 255, 0.1);
            }

            #workspaces button.urgent {
              background-color: #eb4d4b;
            }

            #window,
            #workspaces {
              margin: 0 4px;
            }

            .modules-left > widget:first-child > #workspaces {
              margin-left: 0;
            }

            .modules-right > widget:last-child > #workspaces {
              margin-right: 0;
            }

            #clock,
            #battery,
            #pulseaudio,
            #network,
            #tray {
              padding: 0 10px;
              margin: 0 3px;
              border-radius: 6px;
            }

            #window {
              font-weight: normal;
              padding: 0 10px;
            }

            #tray > .passive {
              -gtk-icon-effect: dim;
            }

            #tray > .needs-attention {
              -gtk-icon-effect: highlight;
            }

            #battery.charging, #battery.plugged {
              background-color: #26A65B;
            }

            @keyframes blink {
              to {
                background-color: #ffffff;
                color: #000000;
              }
            }

            #battery.critical:not(.charging) {
              background-color: #f53c3c;
              color: #ffffff;
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
            }

            label:focus {
              background-color: #000000;
            }
          '';
        };

        # Hyprlock screen locker configuration
        hyprlock = {
          enable = true;
          settings = {
            general = {
              disable_loading_bar = true;
              grace = 300;
              hide_cursor = true;
              no_fade_in = false;
            };

            background = [
              {
                path = "screenshot";
                blur_passes = 3;
                blur_size = 8;
              }
            ];

            input-field = [
              {
                size = "200, 50";
                position = "0, -80";
                monitor = "";
                dots_center = true;
                fade_on_empty = false;
                font_color = "rgb(202, 211, 245)";
                inner_color = "rgb(91, 96, 120)";
                outer_color = "rgb(24, 25, 38)";
                outline_thickness = 5;
                placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
                shadow_passes = 2;
              }
            ];
          };
        };

        # Wlogout configuration
        wlogout = {
          enable = true;
          layout = [
            {
              label = "lock";
              action = "hyprlock";
              text = "Lock";
              keybind = "l";
            }
            {
              label = "hibernate";
              action = "systemctl hibernate";
              text = "Hibernate";
              keybind = "h";
            }
            {
              label = "logout";
              action = "hyprctl dispatch exit";
              text = "Logout";
              keybind = "e";
            }
            {
              label = "shutdown";
              action = "systemctl poweroff";
              text = "Shutdown";
              keybind = "s";
            }
            {
              label = "suspend";
              action = "systemctl suspend";
              text = "Suspend";
              keybind = "u";
            }
            {
              label = "reboot";
              action = "systemctl reboot";
              text = "Reboot";
              keybind = "r";
            }
          ];
        };
      };

      # Service configurations
      services = {
        # SwayNC (Sway Notification Center) configuration
        swaync = {
          enable = true;
          settings = {
            positionX = "right";
            positionY = "top";
            layer = "overlay";
            control-center-layer = "top";
            layer-shell = true;
            cssPriority = "application";
            control-center-margin-top = 8;
            control-center-margin-bottom = 8;
            control-center-margin-right = 8;
            control-center-margin-left = 8;
            notification-2fa-action = true;
            notification-inline-replies = false;
            notification-icon-size = 64;
            notification-body-image-height = 100;
            notification-body-image-width = 200;
            timeout = 10;
            timeout-low = 5;
            timeout-critical = 0;
            fit-to-screen = true;
            control-center-width = 500;
            control-center-height = 600;
            notification-window-width = 500;
            keyboard-shortcuts = true;
            image-visibility = "when-available";
            transition-time = 200;
            hide-on-clear = false;
            hide-on-action = true;
            script-fail-notify = true;
          };
        };

        # Hypridle idle daemon configuration
        hypridle = {
          enable = true;
          settings = {
            general = {
              after_sleep_cmd = "hyprctl dispatch dpms on";
              ignore_dbus_inhibit = false;
              lock_cmd = "hyprlock";
            };

            listener = [
              {
                timeout = 900;
                on-timeout = "hyprlock";
              }
              {
                timeout = 1200;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
            ];
          };
        };

        # Hyprpaper wallpaper daemon configuration
        hyprpaper = {
          enable = true;
          settings = {
            ipc = "on";
            splash = false;
            splash_offset = 2.0;

            preload = [
              "~/Pictures/Wallpapers/among-trees-campsite.jpg"
            ];

            wallpaper = [
              ",~/Pictures/Wallpapers/among-trees-campsite.jpg"
            ];
          };
        };
      };

      # Configure zathura PDF viewer
      programs.zathura = {
        enable = true;
        options = {
          selection-clipboard = "clipboard";
          adjust-open = "best-fit";
          pages-per-row = 1;
          scroll-page-aware = "true";
          scroll-full-overlap = 0.01;
          scroll-step = 50;
          zoom-min = 10;
          guioptions = "none";
          font = "JetBrainsMono Nerd Font 12";
        };
      };

      # Create Screenshots directory
      home.file."Pictures/Screenshots/.keep".text = "";

      # Additional utility programs
      home.packages = with pkgs; [
        # Wallpaper manager
        waypaper

        # Color picker
        hyprpicker

        # Additional utilities for screenshots and clipboard
        wl-clipboard-rs
        grim
        slurp
        swappy
        hyprshot # Hyprland-specific screenshot tool
      ];
    };
  };
}
