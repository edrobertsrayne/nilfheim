_: {
  flake.modules.darwin.yabai = {
    config,
    lib,
    ...
  }: let
    yabaiCfg = config.services.yabai;
  in {
    config = lib.mkIf yabaiCfg.enable {
      services.skhd = {
        enable = true;

        skhdConfig = ''
          # ================================================================
          # Application Launchers
          # ================================================================
          # Note: Raycast handles app launching (Cmd+Space by default)
          # These are direct app keybinds mirroring Hyprland

          # Terminal (mirrors Hyprland's SUPER+Return)
          cmd - return : open -na /Applications/WezTerm.app

          # Browser (mirrors Hyprland's SUPER+SHIFT+B)
          cmd + shift - b : open -na "/Applications/Google Chrome.app"

          # File manager (mirrors Hyprland's SUPER+SHIFT+E)
          cmd + shift - e : open -na /System/Applications/Finder.app

          # ================================================================
          # Window Focus (Both vi keys and arrows)
          # ================================================================
          # Vi-style (Alt+h/j/k/l) - recommended to avoid conflicts
          alt - h : yabai -m window --focus west
          alt - j : yabai -m window --focus south
          alt - k : yabai -m window --focus north
          alt - l : yabai -m window --focus east

          # Arrow keys (Cmd+arrows) - mirrors Hyprland more closely
          cmd - left : yabai -m window --focus west
          cmd - down : yabai -m window --focus south
          cmd - up : yabai -m window --focus north
          cmd - right : yabai -m window --focus east

          # Cycle through windows (like Alt+Tab in Hyprland)
          # Note: native macOS Cmd+Tab is for apps, this is for windows
          alt - tab : yabai -m window --focus next || yabai -m window --focus first
          alt + shift - tab : yabai -m window --focus prev || yabai -m window --focus last

          # ================================================================
          # Window Swap (Both vi keys and arrows)
          # ================================================================
          # Vi-style swap
          cmd + shift - h : yabai -m window --swap west
          cmd + shift - j : yabai -m window --swap south
          cmd + shift - k : yabai -m window --swap north
          cmd + shift - l : yabai -m window --swap east

          # Arrow key swap
          cmd + shift - left : yabai -m window --swap west
          cmd + shift - down : yabai -m window --swap south
          cmd + shift - up : yabai -m window --swap north
          cmd + shift - right : yabai -m window --swap east

          # ================================================================
          # Window Warp (move window and swap spaces)
          # ================================================================
          # Vi-style warp
          cmd + ctrl - h : yabai -m window --warp west
          cmd + ctrl - j : yabai -m window --warp south
          cmd + ctrl - k : yabai -m window --warp north
          cmd + ctrl - l : yabai -m window --warp east

          # Arrow key warp
          cmd + ctrl - left : yabai -m window --warp west
          cmd + ctrl - down : yabai -m window --warp south
          cmd + ctrl - up : yabai -m window --warp north
          cmd + ctrl - right : yabai -m window --warp east

          # ================================================================
          # Window Resize
          # ================================================================
          # Resize windows (try to expand in direction, fallback to shrinking opposite)
          cmd + alt - left : yabai -m window --resize left:-50:0 || yabai -m window --resize right:-50:0
          cmd + alt - down : yabai -m window --resize bottom:0:50 || yabai -m window --resize top:0:50
          cmd + alt - up : yabai -m window --resize top:0:-50 || yabai -m window --resize bottom:0:-50
          cmd + alt - right : yabai -m window --resize right:50:0 || yabai -m window --resize left:50:0

          # Vi-style resize (same as arrows, for consistency)
          cmd + alt - h : yabai -m window --resize left:-50:0 || yabai -m window --resize right:-50:0
          cmd + alt - j : yabai -m window --resize bottom:0:50 || yabai -m window --resize top:0:50
          cmd + alt - k : yabai -m window --resize top:0:-50 || yabai -m window --resize bottom:0:-50
          cmd + alt - l : yabai -m window --resize right:50:0 || yabai -m window --resize left:50:0

          # ================================================================
          # Window Actions
          # ================================================================
          # Toggle float (mirrors Hyprland's SUPER+T but adapted for macOS conventions)
          cmd + shift - space : yabai -m window --toggle float --grid 4:4:1:1:2:2

          # Fullscreen (native macOS fullscreen)
          cmd + ctrl - f : yabai -m window --toggle zoom-fullscreen

          # Native fullscreen (macOS native, uses Mission Control)
          cmd + shift - f : yabai -m window --toggle native-fullscreen

          # Toggle window zoom (parent container zoom)
          cmd + shift - d : yabai -m window --toggle zoom-parent

          # Toggle split direction
          cmd - e : yabai -m window --toggle split

          # Close window (careful: conflicts with native Cmd+W in many apps)
          # Using Cmd+Shift+W instead to avoid conflicts
          cmd + shift - w : yabai -m window --close

          # ================================================================
          # Layout Actions
          # ================================================================
          # Rotate tree clockwise
          cmd + shift - r : yabai -m space --rotate 90

          # Rotate tree counter-clockwise
          cmd + shift + alt - r : yabai -m space --rotate 270

          # Mirror tree on x-axis (horizontal flip)
          cmd + shift - x : yabai -m space --mirror x-axis

          # Mirror tree on y-axis (vertical flip)
          cmd + shift - y : yabai -m space --mirror y-axis

          # Balance windows (equalize all window sizes)
          cmd + shift - 0 : yabai -m space --balance

          # Toggle layout between bsp and float for current space
          cmd + shift - t : yabai -m space --layout $(yabai -m query --spaces --space | jq -r 'if .type == "bsp" then "float" else "bsp" end')

          # ================================================================
          # Display Focus (Multi-monitor)
          # ================================================================
          # Focus display by direction
          cmd + alt + ctrl - left : yabai -m display --focus west
          cmd + alt + ctrl - right : yabai -m display --focus east

          # Focus display by number
          cmd + alt - 1 : yabai -m display --focus 1
          cmd + alt - 2 : yabai -m display --focus 2
          cmd + alt - 3 : yabai -m display --focus 3

          # ================================================================
          # Move Window to Display
          # ================================================================
          # Send window to display and follow focus
          cmd + shift + alt - left : yabai -m window --display west; yabai -m display --focus west
          cmd + shift + alt - right : yabai -m window --display east; yabai -m display --focus east

          # Send window to display by number and follow focus
          cmd + shift + alt - 1 : yabai -m window --display 1; yabai -m display --focus 1
          cmd + shift + alt - 2 : yabai -m window --display 2; yabai -m display --focus 2
          cmd + shift + alt - 3 : yabai -m window --display 3; yabai -m display --focus 3

          # ================================================================
          # Space Navigation (Native macOS Spaces)
          # ================================================================
          # Note: yabai cannot create/destroy spaces with SIP enabled
          # Use native macOS Spaces navigation (Mission Control)
          # These are commented out as they require Mission Control keyboard shortcuts
          # to be configured in System Settings > Keyboard > Shortcuts > Mission Control

          # Uncomment and configure in System Settings if desired:
          # ctrl - left : yabai -m space --focus prev (via Mission Control)
          # ctrl - right : yabai -m space --focus next (via Mission Control)
          # ctrl - 1 : # Switch to Desktop 1 (via Mission Control)
          # ctrl - 2 : # Switch to Desktop 2 (via Mission Control)

          # ================================================================
          # Restart yabai
          # ================================================================
          # Restart yabai service (useful after config changes)
          cmd + shift + alt - r : launchctl kickstart -k "gui/''${UID}/org.nixos.yabai"
        '';
      };
    };
  };
}
