{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: let
    inherit (inputs.self.nilfheim.desktop) terminal launcher;
    browser-launcher = lib.getExe inputs.self.packages.${pkgs.system}.nilfheim-launch-browser;
  in {
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      bind =
        [
          # Window management
          "$mod, W, killactive"
          "$mod, Q, killactive"
          "$mod, T, togglefloating"
          "$mod, F, fullscreen"
          "$mod ALT, F, fullscreenstate, 0 2" # Full width (maximize vertically only)

          # Applications
          "$mod, RETURN, exec, ${terminal}"
          "$mod SHIFT, B, exec, ${browser-launcher}"
          "$mod SHIFT ALT, B, exec, ${browser-launcher} --private"
          "$mod, SPACE, exec, ${launcher}"

          # Close all windows
          "CTRL ALT, Delete, exec, hyprctl clients -j | ${lib.getExe pkgs.jq} -r '.[].address' | xargs -I {} hyprctl dispatch closewindow address:{}"

          # Workspace navigation
          "$mod, Tab, workspace, e+1"
          "$mod SHIFT, Tab, workspace, e-1"
          "$mod CTRL, Tab, workspace, previous"

          # Window focus (directional)
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          # Window swap (directional)
          "$mod SHIFT, left, swapwindow, l"
          "$mod SHIFT, right, swapwindow, r"
          "$mod SHIFT, up, swapwindow, u"
          "$mod SHIFT, down, swapwindow, d"

          # Window resize
          "$mod, equal, resizeactive, -40 0" # Grow left
          "$mod, minus, resizeactive, 40 0" # Grow right
          "$mod SHIFT, equal, resizeactive, 0 40" # Grow down
          "$mod SHIFT, minus, resizeactive, 0 -40" # Grow up

          # Window grouping (tabbed containers)
          "$mod, G, togglegroup"
          "$mod ALT, G, moveoutofgroup"
          "$mod ALT, Tab, changegroupactive"

          # Move window into group (directional)
          "$mod ALT, left, moveintogroup, l"
          "$mod ALT, right, moveintogroup, r"
          "$mod ALT, up, moveintogroup, u"
          "$mod ALT, down, moveintogroup, d"

          # Jump to specific window in group (1-4)
          "$mod ALT, 1, changegroupactive, 0"
          "$mod ALT, 2, changegroupactive, 1"
          "$mod ALT, 3, changegroupactive, 2"
          "$mod ALT, 4, changegroupactive, 3"

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

          # Keyboard layout toggle (all keyboards: gb ↔ us)
          "$mod SHIFT, L, exec, hyprctl switchxkblayout all next"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
