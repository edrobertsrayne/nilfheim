_: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "float,class:^(pavucontrol)$"
      "float,class:^(blueman-manager)$"
      "float,class:^(nm-connection-editor)$"
      "float,class:^(file-roller)$"
      "float,class:^(org.gnome.Nautilus)$"
      "float,class:^(cliphist)$"
      "float,class:^(hyprpolkitagent)$"
      "float,class:^(gcr-prompter)$"
      "float,title:^(Picture-in-Picture)$"
      "pin,title:^(Picture-in-Picture)$"
      "opacity 0.85,class:^(org.gnome.Nautilus)$"
      "opacity 0.95,class:^(pavucontrol)$"
      "opacity 0.95,class:^(blueman-manager)$"
      "size 800 600,class:^(pavucontrol)$"
      "size 700 500,class:^(blueman-manager)$"
    ];
  };
}
