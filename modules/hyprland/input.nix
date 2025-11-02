_: {
  flake.modules.home.hyprland = {
    wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = "gb,us";
        kb_options = "compose:caps";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
        sensitivity = 0;
      };
    };
  };
}
