_: {
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      settings = {
        bindd = [
          "SUPER, V, Passthrough mode, submap, Passthrough"
          "ALT, R, Window resize mode, submap, Resize"
          "ALT, M, Media control mode, submap, Media"
        ];
      };
      submaps = {
        Passthrough = {
          settings.bind = [
            ", escape, submap, reset"
          ];
        };
        Resize = {
          settings = {
            binde = [
              ", right, resizeactive, 10 0"
              ", left, resizeactive, -10 0"
              ", up, resizeactive, 0 -10"
              ", down, resizeactive, 0 10"
            ];
            bind = [
              ", escape, submap, reset"
              ", catchall, submap, reset"
            ];
          };
        };
        Media = {
          settings.bind = [
            ", I, exec, playerctl previous"
            ", O, exec, playerctl play-pause"
            ", P, exec, playerctl next"
            ", catchall, submap, reset"
          ];
        };
      };
    };
  };
}
