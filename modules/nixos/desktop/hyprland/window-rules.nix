_: {
  # Hyprland window rules and workspace configuration
  wayland.windowManager.hyprland.settings = {
    # Window rules
    windowrulev2 = [
      "float,class:^(rofi)$"
      "float,class:^(pavucontrol)$"
      "float,class:^(blueman-manager)$"
      "float,class:^(nm-connection-editor)$"
      "float,class:^(file-roller)$"
      "float,class:^(thunar)$"
      "float,class:^(cliphist)$"
      "float,class:^(polkit-gnome-authentication-agent-1)$"
      "float,class:^(gcr-prompter)$"
      "float,title:^(Picture-in-Picture)$"
      "pin,title:^(Picture-in-Picture)$"
      "opacity 0.85,class:^(thunar)$"
      "opacity 0.9,class:^(foot)$"
      "opacity 0.95,class:^(pavucontrol)$"
      "opacity 0.95,class:^(blueman-manager)$"
      "size 800 600,class:^(pavucontrol)$"
      "size 700 500,class:^(blueman-manager)$"
      "workspace 4,class:^(discord)$"
      "workspace 4,class:^(Discord)$"
      "workspace 3,class:^(vlc)$"
      "workspace 2,class:^(gimp)$"
      "workspace 2,class:^(Gimp)$"
      "workspace 2,class:^(inkscape)$"
      "workspace 2,class:^(Inkscape)$"
    ];

    # Workspace rules
    workspace = [
      "1, monitor:DP-1, default:true" # General workspace
      "2, monitor:DP-1" # Graphics/Design (GIMP, Inkscape)
      "3, monitor:DP-1" # Media (VLC)
      "4, monitor:DP-1" # Communication (Discord)
    ];
  };
}
