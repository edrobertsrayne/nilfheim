{pkgs, ...}: {
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
        /* Catppuccin Mocha color scheme */
        * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-weight: bold;
          font-size: 13px;
          min-height: 0;
        }

        window#waybar {
          background-color: #1e1e2e; /* Catppuccin Mocha base */
          color: #cdd6f4; /* Catppuccin Mocha text */
          border-bottom: 3px solid #313244; /* Catppuccin Mocha surface0 */
          transition-property: background-color;
          transition-duration: 0.5s;
        }

        button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
          color: #cdd6f4; /* Catppuccin Mocha text */
        }

        #workspaces button {
          padding: 0 8px;
          background-color: transparent;
          color: #6c7086; /* Catppuccin Mocha overlay1 */
        }

        #workspaces button:hover {
          background-color: #45475a; /* Catppuccin Mocha surface2 */
          color: #cdd6f4; /* Catppuccin Mocha text */
          box-shadow: inherit;
        }

        #workspaces button.active {
          background-color: #89b4fa; /* Catppuccin Mocha blue */
          color: #1e1e2e; /* Catppuccin Mocha base */
        }

        #workspaces button.urgent {
          background-color: #f38ba8; /* Catppuccin Mocha pink */
          color: #1e1e2e; /* Catppuccin Mocha base */
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
          background-color: #313244; /* Catppuccin Mocha surface0 */
          color: #cdd6f4; /* Catppuccin Mocha text */
        }

        #window {
          font-weight: normal;
          padding: 0 10px;
          color: #cdd6f4; /* Catppuccin Mocha text */
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #f9e2af; /* Catppuccin Mocha yellow */
        }

        #battery.charging, #battery.plugged {
          background-color: #a6e3a1; /* Catppuccin Mocha green */
          color: #1e1e2e; /* Catppuccin Mocha base */
        }

        #pulseaudio {
          background-color: #fab387; /* Catppuccin Mocha peach */
          color: #1e1e2e; /* Catppuccin Mocha base */
        }

        #network {
          background-color: #89dceb; /* Catppuccin Mocha sky */
          color: #1e1e2e; /* Catppuccin Mocha base */
        }

        #clock {
          background-color: #b4befe; /* Catppuccin Mocha lavender */
          color: #1e1e2e; /* Catppuccin Mocha base */
        }

        @keyframes blink {
          to {
            background-color: #cdd6f4; /* Catppuccin Mocha text */
            color: #1e1e2e; /* Catppuccin Mocha base */
          }
        }

        #battery.critical:not(.charging) {
          background-color: #f38ba8; /* Catppuccin Mocha pink */
          color: #cdd6f4; /* Catppuccin Mocha text */
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        label:focus {
          background-color: #45475a; /* Catppuccin Mocha surface2 */
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

    # Configure zathura PDF viewer
    zathura = {
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
  };
}
