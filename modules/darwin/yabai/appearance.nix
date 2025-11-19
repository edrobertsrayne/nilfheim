_: {
  flake.modules.darwin.yabai = {
    config,
    lib,
    ...
  }: let
    cfg = config.services.yabai;
  in {
    config = lib.mkIf cfg.enable {
      services.yabai.config = {
        # Layout mode
        layout = "bsp"; # Binary space partitioning (similar to Hyprland's dwindle)
        window_placement = "second_child"; # New windows go to right/bottom

        # Gaps and padding (12px all around)
        window_gap = 12;
        top_padding = 12;
        bottom_padding = 12;
        left_padding = 12;
        right_padding = 12;

        # Mouse behavior
        focus_follows_mouse = "autoraise"; # Auto-focus and raise window under cursor
        mouse_follows_focus = "off"; # Don't move cursor when changing focus via keyboard

        # Mouse modifier for manual window manipulation
        mouse_modifier = "fn"; # Fn key for dragging windows/resizing
        mouse_action1 = "move"; # Fn + left click = move window
        mouse_action2 = "resize"; # Fn + right click = resize window

        # Window behavior
        window_shadow = "float"; # Shadows only on floating windows
        window_opacity = "off"; # No opacity control (requires SIP disabled)
        window_animation_duration = 0.0; # Disable animations (limited with SIP enabled)

        # Split behavior
        split_ratio = 0.50; # 50/50 split for new windows
        auto_balance = "off"; # Don't auto-balance on window close (manual balance via keybind)
      };
    };
  };
}
