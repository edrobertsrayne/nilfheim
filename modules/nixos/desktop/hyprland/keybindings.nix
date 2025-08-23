_: {
  # Hyprland keybindings configuration
  wayland.windowManager.hyprland.settings = {
    # Key modifier
    "$mod" = "SUPER";

    # Keyboard bindings
    bind = [
      # Applications
      "$mod, Return, exec, foot"
      "$mod, Space, exec, rofi -show drun"
      "$mod, B, exec, firefox"
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

      # Media and graphics
      "$mod SHIFT, V, exec, vlc"
      "$mod SHIFT, G, exec, gimp"
      "$mod SHIFT, I, exec, inkscape"

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
  };
}
