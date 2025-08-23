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
          modules-right = ["tray" "custom/hypridle" "pulseaudio" "network" "battery" "clock"];

          # Workspaces configuration - show first 5 workspaces
          "hyprland/workspaces" = {
            disable-scroll = false;
            all-outputs = true;
            format = "{name}";
            persistent-workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
            };
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

          # Custom hypridle toggle (caffeine-like functionality)
          "custom/hypridle" = {
            format = "{}";
            exec = ''if pgrep hypridle > /dev/null; then echo "󰅶"; else echo "󰛊"; fi'';
            on-click = ''if pgrep hypridle > /dev/null; then pkill hypridle && notify-send "Hypridle" "Disabled"; else hypridle & notify-send "Hypridle" "Enabled"; fi'';
            tooltip-format = "Toggle hypridle (caffeine mode)";
            interval = 5;
          };

          # Audio with proper icons
          pulseaudio = {
            format = "{icon} {volume}%";
            format-bluetooth = "{icon}  {volume}%";
            format-bluetooth-muted = " ";
            format-muted = " ";
            format-source = "{volume}% ";
            format-source-muted = "";
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
            tooltip-format = "Volume: {volume}%";
          };

          # Network with dynamic icons and network name
          network = {
            format-wifi = "  {essid}";
            format-ethernet = "  Wired";
            tooltip-format = "{ipaddr}";
            format-linked = "  No IP";
            format-disconnected = "  Disconnected";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            on-click = "nm-connection-editor";
            interval = 5;
          };

          # Battery with charging states and proper icons
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "  {capacity}%";
            format-plugged = "  {capacity}%";
            format-full = "  {capacity}%";
            format-alt = "{icon} {time}";
            format-icons = ["" "" "" "" ""];
            tooltip-format = "{capacity}% - {timeTo}";
          };

          # Clock with icon and date
          clock = {
            format = "  {:%a %b %d  %H:%M}";
            format-alt = "  {:%Y-%m-%d  %H:%M:%S}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
        };
      };

      style = ''
        /* Minimal Catppuccin Mocha - colored text, uniform backgrounds */
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
          padding: 0 12px;
          background-color: transparent;
          color: #6c7086; /* Catppuccin Mocha overlay1 */
          margin: 0 2px;
          transition: all 0.3s ease;
        }

        #workspaces button:hover {
          background-color: #89b4fa; /* Catppuccin Mocha blue - inverted from active text */
          color: #1e1e2e; /* Catppuccin Mocha base - inverted from active background */
          border-radius: 6px;
        }

        #workspaces button.active {
          background-color: #313244; /* Catppuccin Mocha surface0 */
          color: #89b4fa; /* Catppuccin Mocha blue */
          border-radius: 6px;
        }

        #workspaces button.urgent {
          background-color: #313244; /* Catppuccin Mocha surface0 */
          color: #f38ba8; /* Catppuccin Mocha pink */
          border-radius: 6px;
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

        /* All modules have uniform background, colored text */
        #clock,
        #battery,
        #pulseaudio,
        #network,
        #tray,
        #custom-hypridle {
          padding: 0 12px;
          margin: 0 2px;
          background-color: transparent;
          border-radius: 0;
        }

        #window {
          font-weight: normal;
          padding: 0 10px;
          color: #cdd6f4; /* Catppuccin Mocha text */
        }

        /* Colored text for different modules */
        #pulseaudio {
          color: #fab387; /* Catppuccin Mocha peach */
        }

        #network {
          color: #89dceb; /* Catppuccin Mocha sky */
        }

        #network.disconnected {
          color: #f38ba8; /* Catppuccin Mocha pink */
        }

        #battery {
          color: #a6e3a1; /* Catppuccin Mocha green */
        }

        #battery.warning {
          color: #f9e2af; /* Catppuccin Mocha yellow */
        }

        #battery.critical:not(.charging) {
          color: #f38ba8; /* Catppuccin Mocha pink */
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #clock {
          color: #b4befe; /* Catppuccin Mocha lavender */
        }

        #custom-hypridle {
          color: #f9e2af; /* Catppuccin Mocha yellow */
          font-size: 16px;
        }

        #tray {
          color: #cdd6f4; /* Catppuccin Mocha text */
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          color: #f9e2af; /* Catppuccin Mocha yellow */
        }

        @keyframes blink {
          to {
            color: #cdd6f4; /* Catppuccin Mocha text */
          }
        }

        label:focus {
          background-color: #313244; /* Catppuccin Mocha surface0 */
          border-radius: 6px;
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
