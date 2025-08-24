_: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = [
          "tray"
          "custom/hypridle"
          "custom/hyprsunset"
          "brightness"
          "cpu"
          "memory"
          "pulseaudio"
          # "network"
          "battery"
          "clock"
          "custom/lock"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          active-only = false;
          all-outputs = true;
          on-click = "activate";
          sort-by-number = true;
          format = "{}";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
          max-length = 50;
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };

        "custom/hypridle" = {
          format = "{}";
          exec = ''if pgrep hypridle > /dev/null; then echo "󰅶"; else echo "󰛊"; fi'';
          on-click = ''if pgrep hypridle > /dev/null; then pkill hypridle && notify-send "Hypridle" "Disabled"; else hypridle & notify-send "Hypridle" "Enabled"; fi'';
          tooltip-format = "Toggle hypridle (caffeine mode)";
          interval = 5;
        };

        "custom/hyprsunset" = {
          format = "{}";
          exec = ''if pgrep hyprsunset > /dev/null; then echo "󰌶"; else echo "󰌵"; fi'';
          on-click = ''if pgrep hyprsunset > /dev/null; then pkill hyprsunset && notify-send "Hyprsunset" "Blue light filter disabled"; else hyprsunset & notify-send "Hyprsunset" "Blue light filter enabled"; fi'';
          tooltip-format = "Toggle blue light filter";
          interval = 5;
        };

        backlight = {
          tooltip = false;
          format = "  {}%";
          interval = 1;
          on-scroll-up = "light -A 5";
          on-scroll-down = "light -U 5";
        };

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

        clock = {
          format = "{icon} {:%H:%M}";
          format-alt = " {:%d/%m/%Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          interval = 15;
          format = "  {}%";
          max-length = 10;
        };

        memory = {
          interval = 30;
          format = "  {}%";
          max-length = 10;
        };

        "custom/lock" = {
          format = "";
          tooltip = false;
          on-click = "hyprlock &";
        };

        "custom/power" = {
          on-click = "wlogout &";
          format = "";
          tooltip = false;
        };
      };
    };

    style = builtins.readFile ./waybar.css;
  };
}
