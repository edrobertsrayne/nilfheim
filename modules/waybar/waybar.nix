_: {
  flake.modules.homeManager.waybar = {
    pkgs,
    lib,
    config,
    ...
  }: {
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          reload_style_on_change = true;
          layer = "top";
          position = "top";
          spacing = 0;
          height = 28;

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
            on-click = "xdg-terminal-exec --app-id=Wiremix -e ${lib.getExe pkgs.wiremix}";
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
            on-click = "xdg-terminal-exec --app-id=Niflheim -e nmtui";
            interval = 3;
            spacing = 1;
          };

          battery = {
            states = {
              warning = 25;
              critical = 10;
            };
            format = "{icon}";
            format-plugged = "󰚥";
            format-full = "󱈑";
            format-alt = "{icon} {time}";
            format-icons = {
              default = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󱈑"];
              charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
            };
            tooltip-format-discharging = "{capacity} %";
            tooltip-format-charging = "{time} until full";
          };

          bluetooth = {
            format = "";
            format-disabled = "󰂲";
            format-connected = "";
            tooltip-format = "Devices connected: {num_connections}";
            on-click = lib.getExe' pkgs.blueman "blueman";
          };

          clock = {
            format = "{:L%A %H:%M}";
            format-alt = " {:L%d %B W%V %Y}";
            tooltip = false;
          };

          cpu = {
            interval = 15;
            format = " ";
            on-click = "xdg-terminal-exec --app-id=Niflheim -e ${lib.getExe pkgs.btop}";
          };
        };
      };

      style = with config.lib.stylix.colors.withHashtag;
        ''
          @define-color base00 ${base00}; @define-color base01 ${base01};
          @define-color base02 ${base02}; @define-color base03 ${base03};
          @define-color base04 ${base04}; @define-color base05 ${base05};
          @define-color base06 ${base06}; @define-color base07 ${base07};
          @define-color base08 ${base08}; @define-color base09 ${base09};
          @define-color base0A ${base0A}; @define-color base0B ${base0B};
          @define-color base0C ${base0C}; @define-color base0D ${base0D};
          @define-color base0E ${base0E}; @define-color base0F ${base0F};

          * {
            font-family: "${config.stylix.fonts.monospace.name}";
            font-size: ${toString config.stylix.fonts.sizes.desktop}pt;
          }
        ''
        + (builtins.readFile ./waybar.css);
    };
  };
}
