_: {
  # Waybar status bar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 2;

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

        # System tray with nerd font icon support
        tray = {
          icon-size = 21;
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

        # Audio with nerd font icons
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}  {volume}%";
          format-bluetooth-muted = "󰂲 ";
          format-muted = "󰖁 ";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭 ";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󱡒";
            headset = "󰋎";
            phone = "󰄜";
            portable = "󰦧";
            car = "󰄋";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pavucontrol";
          tooltip-format = "Volume: {volume}%";
        };

        # Network with nerd font icons and network name
        network = {
          format-wifi = "󰖩  {essid}";
          format-ethernet = "󰈀  Wired";
          tooltip-format = "{ipaddr}";
          format-linked = "󰖪  No IP";
          format-disconnected = "󰖪  Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
          interval = 5;
        };

        # Battery with nerd font icons and charging states
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-full = "󱈑 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󱈑"];
          tooltip-format = "{capacity}% - {timeTo}";
        };

        # Clock without icon for cleaner look
        clock = {
          format = "{:%a %b %d  %H:%M}";
          format-alt = "{:%Y-%m-%d  %H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
      };
    };

    style = ''
      /* Minimal Catppuccin Mocha - colored text, uniform backgrounds */
      * {
        border: none;
        border-radius: 0;
        font-family: "Noto Sans Nerd Font", "Noto Sans", sans-serif;
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
        margin: 0 1px;
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
        margin: 0 2px;
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
        padding: 0 8px;
        margin: 0 1px;
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
}
