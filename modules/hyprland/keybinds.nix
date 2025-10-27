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
      bind =
        [
          # Window management
          "SUPER, W, killactive"
          "SUPER, Q, killactive"
          "SUPER, T, togglefloating"
          "SUPER, F, fullscreen"
          "SUPER, P, pseudo"
          "SUPER CTRL, F, fullscreenstate, 0 2"
          "SUPER, J, togglesplit"

          # Applications
          "SUPER, RETURN, exec, ${terminal}"
          "SUPER SHIFT, B, exec, ${browser-launcher}"
          "SUPER SHIFT ALT, B, exec, ${browser-launcher} --private"
          "SUPER, SPACE, exec, ${launcher}"

          # Close all windows
          "CTRL ALT, Delete, exec, hyprctl clients -j | ${lib.getExe pkgs.jq} -r '.[].address' | xargs -I {} hyprctl dispatch closewindow address:{}"

          # Workspace navigation
          "SUPER, Tab, workspace, e+1"
          "SUPER SHIFT, Tab, workspace, e-1"
          "SUPER CTRL, Tab, workspace, previous"

          # Window focus (directional)
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          # Window cycling (Alt-Tab)
          "ALT, Tab, cyclenext"
          "ALT SHIFT, Tab, cyclenext, prev"

          # Window swap (directional)
          "SUPER SHIFT, left, swapwindow, l"
          "SUPER SHIFT, right, swapwindow, r"
          "SUPER SHIFT, up, swapwindow, u"
          "SUPER SHIFT, down, swapwindow, d"

          # Window resize
          "SUPER, equal, resizeactive, -40 0" # Grow left
          "SUPER, minus, resizeactive, 40 0" # Grow right
          "SUPER SHIFT, equal, resizeactive, 0 40" # Grow down
          "SUPER SHIFT, minus, resizeactive, 0 -40" # Grow up

          # Window grouping (tabbed containers)
          "SUPER, G, togglegroup"
          "SUPER ALT, G, moveoutofgroup"
          "SUPER ALT, Tab, changegroupactive"
          "SUPER ALT SHIFT, Tab, changegroupactive, b"

          # Move window into group (directional)
          "SUPER ALT, left, moveintogroup, l"
          "SUPER ALT, right, moveintogroup, r"
          "SUPER ALT, up, moveintogroup, u"
          "SUPER ALT, down, moveintogroup, d"

          # Jump to specific window in group (1-4)
          "SUPER ALT, 1, changegroupactive, 0"
          "SUPER ALT, 2, changegroupactive, 1"
          "SUPER ALT, 3, changegroupactive, 2"
          "SUPER ALT, 4, changegroupactive, 3"

          # Keyboard layout toggle (all keyboards: gb ↔ us)
          "SUPER SHIFT, L, exec, hyprctl switchxkblayout all next"
        ]
        ++ (
          # workspaces
          # binds SUPER + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "SUPER, code:1${toString i}, workspace, ${toString ws}"
                "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      # Volume and brightness controls (with repeat on hold)
      bindel = [
        # Volume controls
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"

        # Brightness controls
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

        # Precise volume adjustments
        "ALT, XF86AudioRaiseVolume, exec, swayosd-client --output-volume +1"
        "ALT, XF86AudioLowerVolume, exec, swayosd-client --output-volume -1"

        # Precise brightness adjustments
        "ALT, XF86MonBrightnessUp, exec, swayosd-client --brightness +1"
        "ALT, XF86MonBrightnessDown, exec, swayosd-client --brightness -1"
      ];

      # Media controls (work when locked)
      bindl = [
        ", XF86AudioPlay, exec, swayosd-client --playerctl play-pause"
        ", XF86AudioNext, exec, swayosd-client --playerctl next"
        ", XF86AudioPrev, exec, swayosd-client --playerctl previous"
      ];

      # Mouse bindings
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
