{
  config,
  pkgs,
  lib,
  ...
}: let
  terminal = lib.getExe pkgs.alacritty;
  inherit (config.lib.stylix) colors;
in {
  stylix.targets.waybar.enable = false;
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        reload_style_on_change = true;
        layer = "top";
        position = "top";
        spacing = 0;
        height = 26;

        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = [
          "bluetooth"
          "network"
          "pulseaudio"
          "cpu"
          "battery"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          sort-by-number = true;
          format = "{icon}";
          format-icons = {
            default = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            active = "󱓻";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };

        pulseaudio = {
          format = "{icon}";
          format-bluetooth = "{icon}";
          format-bluetooth-muted = "󰂲";
          format-muted = "󰖁";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󱡒";
            headset = "󰋎";
            phone = "󰄜";
            portable = "󰦧";
            car = "󰄋";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "${terminal} --class=Wiremix -e ${lib.getExe pkgs.wiremix}";
          on-click-right = "${lib.getExe pkgs.pamixer} -t";
          tooltip-format = "Volume: {volume}%";
        };

        network = {
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-wifi = "{icon}";
          format = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰤮";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          on-click = "${terminal} -e nmtui";
          interval = 3;
          spacing = 1;
        };

        battery = {
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-charging = "{icon}";
          format-discharging = "{icon}";
          format-plugged = "󰚥";
          format-full = "󱈑";
          format-alt = "{icon} {time}";
          format-icons = {
            default = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󱈑"];
            charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
          };
          tooltip-format-discharging = "{capacity}%";
          tooltip-format-charging = "{capacity}%";
        };

        bluetooth = {
          format = "";
          format-disabled = "󰂲";
          format-connected = "";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = lib.getExe pkgs.blueberry;
        };

        clock = {
          format = "{:L%A %H:%M}";
          format-alt = " {:L%d %B W%V %Y}";
          tooltip = false;
        };

        cpu = {
          interval = 15;
          format = " ";
          on-click = "${terminal} -e ${lib.getExe pkgs.btop}";
        };
      };
    };

    style = pkgs.replaceVars ./waybar.css {
      font = config.stylix.fonts.monospace.name;
      background = colors.withHashtag.base00;
      foreground = colors.withHashtag.base05;
    };
  };
}
