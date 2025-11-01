# Hyprland Shortcuts - Nilfheim Configuration

## Quick Reference Card

**Most Used Commands**:

```text
Super+Return          Open terminal
Super+Space           Application launcher
Super+Alt+Space       Main menu
Super+Shift+B         Open browser
Super+W/Q             Close window
Super+F               Fullscreen
Super+T               Toggle floating
Super+1-9             Switch to workspace 1-9
Alt+Tab               Next window
Super+Tab             Next workspace
Print                 Screenshot window
```

**Important Notes**:

- **SUPER Key**: Primary modifier (Windows/Command key)
- **Keyboard-First**: Everything accessible via keyboard (inspired by omarchy)
- **Described Keybinds**: All shortcuts include descriptions for hint system
- **Dynamic Workspaces**: Workspaces 1-9 with consistent shift-to-move pattern

---

## Window Management

### Basic Operations

| Shortcut | Action |
|----------|--------|
| `Super+W` | Close window |
| `Super+Q` | Close window (alternative) |
| `Super+T` | Toggle floating mode |
| `Super+F` | Fullscreen current window |
| `Super+Ctrl+F` | Fullscreen on all monitors |
| `Super+P` | Toggle pseudo tiling mode |
| `Super+J` | Toggle split direction (vertical/horizontal) |

### Window Focus

| Shortcut | Action |
|----------|--------|
| `Super+Left` | Focus window to the left |
| `Super+Right` | Focus window to the right |
| `Super+Up` | Focus window above |
| `Super+Down` | Focus window below |
| `Alt+Tab` | Next window (cycle forward) |
| `Alt+Shift+Tab` | Previous window (cycle backward) |

### Window Positioning

| Shortcut | Action |
|----------|--------|
| `Super+Shift+Left` | Swap window to the left |
| `Super+Shift+Right` | Swap window to the right |
| `Super+Shift+Up` | Swap window up |
| `Super+Shift+Down` | Swap window down |

### Window Resizing

| Shortcut | Action |
|----------|--------|
| `Super+=` | Grow window left (shrink width) |
| `Super+-` | Grow window right (expand width) |
| `Super+Shift+=` | Grow window down (expand height) |
| `Super+Shift+-` | Grow window up (shrink height) |

**Note**: Each resize operation changes dimensions by 40 pixels.

---

## Window Grouping (Tabbed Containers)

### Group Management

| Shortcut | Action |
|----------|--------|
| `Super+G` | Toggle window group (create/dissolve) |
| `Super+Alt+G` | Remove window from group |
| `Super+Alt+Tab` | Next window in group |
| `Super+Alt+Shift+Tab` | Previous window in group |

### Add Window to Group

| Shortcut | Action |
|----------|--------|
| `Super+Alt+Left` | Add to group on the left |
| `Super+Alt+Right` | Add to group on the right |
| `Super+Alt+Up` | Add to group above |
| `Super+Alt+Down` | Add to group below |

### Jump to Specific Tab

| Shortcut | Action |
|----------|--------|
| `Super+Alt+1` | Jump to 1st window in group |
| `Super+Alt+2` | Jump to 2nd window in group |
| `Super+Alt+3` | Jump to 3rd window in group |
| `Super+Alt+4` | Jump to 4th window in group |

---

## Workspace Navigation

### Switch Workspaces

| Shortcut | Action |
|----------|--------|
| `Super+1` through `Super+9` | Switch to workspace 1-9 |
| `Super+Tab` | Next workspace |
| `Super+Shift+Tab` | Previous workspace |
| `Super+Ctrl+Tab` | Last active workspace (toggle) |

### Move Windows to Workspaces

| Shortcut | Action |
|----------|--------|
| `Super+Shift+1` through `Super+Shift+9` | Move window to workspace 1-9 |

**Pattern**: Workspace keys use a consistent `Shift` modifier to move windows.

---

## Applications

### Launch Applications

| Shortcut | Action |
|----------|--------|
| `Super+Return` | Open terminal (launch-terminal) |
| `Super+Space` | Application launcher (Walker) |
| `Super+Alt+Space` | Main menu (interactive) |
| `Super+Shift+B` | Open browser (launch-browser) |
| `Super+Shift+Alt+B` | Open browser in private mode |
| `Super+Shift+E` | Open file manager (Nautilus) |
| `Super+Shift+W` | Open wallpaper browser (Waypaper) |
| `Super+Alt+W` | Switch to random wallpaper |

### System Actions

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+Delete` | Close all windows (emergency cleanup) |
| `Super+Shift+L` | Switch keyboard layout (cycle) |

**Note**: The "close all windows" command uses jq to parse Hyprland client list.

---

## Main Menu System

**Shortcut**: `Super+Alt+Space`

The main menu provides organized access to common tasks through a keyboard-driven interface:

### Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Apps** | Launch applications (opens Walker) |
| **Learn** | Access documentation and references |
| **Capture** | Screenshot and color picker tools |
| **Edit Config** | Open Nilfheim configuration in editor |
| **Clean** | Run `nh clean all` to remove old generations |
| **Rebuild** | Run `nh os switch` to rebuild system |
| **About** | Show system information |
| **System** | Lock, suspend, restart, or shutdown |

### Learn Submenu

| Option | Opens |
|--------|-------|
| Keybindings | Interactive keybinding reference |
| NixOS Search | NixOS options search |
| home-manager | Home Manager options documentation |
| nvf | Neovim configuration framework docs |
| Bash | Bash cheatsheet |

### Capture Submenu

| Option | Action |
|--------|--------|
| Grab the whole screen | Screenshot entire screen |
| Grab the current window | Screenshot active window |
| Grab an area | Screenshot selected area |
| Grab a colour | Color picker tool |

### System Submenu

| Option | Action |
|--------|--------|
| Lock | Lock screen (hyprlock) |
| Suspend | Suspend system |
| Restart | Reboot system |
| Shutdown | Power off system |

---

## Screenshot & Color Tools

### Screenshot Shortcuts

| Shortcut | Action |
|----------|--------|
| `Print` | Screenshot current window |
| `Shift+Print` | Screenshot selected area |
| `Alt+Print` | Screenshot current screen |
| `Ctrl+Print` | Screenshot all screens |
| `Super+Print` | Color picker (toggle) |

**Features**:
- Screenshots use **grimblast** for capture
- **Satty** annotation tool opens automatically
- Screenshots saved to `~/Pictures/Screenshots/`
- Copied to clipboard by default
- Timestamp format: `screenshot-YYYYMMDD-HHMMSS.png`

### Color Picker

- Activates **hyprpicker** for color selection
- Press `Super+Print` again to cancel
- Selected color copied to clipboard automatically

---

## Media & Volume Controls

### Volume Controls

| Shortcut | Action |
|----------|--------|
| `XF86AudioRaiseVolume` | Volume up (5% increments) |
| `XF86AudioLowerVolume` | Volume down (5% increments) |
| `XF86AudioMute` | Toggle mute |
| `Alt+XF86AudioRaiseVolume` | Volume up (precise 1% increments) |
| `Alt+XF86AudioLowerVolume` | Volume down (precise 1% increments) |

### Brightness Controls

| Shortcut | Action |
|----------|--------|
| `XF86MonBrightnessUp` | Brightness up (10% increments) |
| `XF86MonBrightnessDown` | Brightness down (10% increments) |
| `Alt+XF86MonBrightnessUp` | Brightness up (precise 1% increments) |
| `Alt+XF86MonBrightnessDown` | Brightness down (precise 1% increments) |

### Media Playback

| Shortcut | Action |
|----------|--------|
| `XF86AudioPlay` | Play/pause current media |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |

**Features**:

- Repeating binds (hold for continuous adjustment)
- Locked binds (work even when screen is locked)
- SwayOSD integration for visual feedback
- Playerctl integration for media controls

---

## Mouse Bindings

| Shortcut | Action |
|----------|--------|
| `Super+Left Click` | Move window (drag) |
| `Super+Right Click` | Resize window (drag) |

**Note**: Mouse support is available but keyboard navigation is preferred following omarchy principles.

---

## Tips & Tricks

1. **Keyboard-First Philosophy**: Following omarchy's design, everything is accessible via keyboard
2. **Described Bindings**: All shortcuts include descriptions for the hint system — press `Super+/` (if configured) to see available shortcuts
3. **Consistent Patterns**:
   - `Super` for actions
   - `Super+Shift` to move windows
   - `Alt` for precise adjustments or alternative behaviors
4. **Window Grouping**: Use `Super+G` to create tabbed containers for better organization
5. **Workspace Shortcuts**: Direct access to 9 workspaces via number keys
6. **Custom Launchers**: `launch-terminal` and `launch-browser` scripts provide enhanced launching functionality

---

## Configuration Location

**Config managed via**:

- `modules/hyprland/keybinds.nix` - Keyboard shortcuts
- `modules/hyprland/menu.nix` - Main menu system
- `modules/hyprland/screenshot.nix` - Screenshot and color picker
- `modules/hyprland/hyprland.nix` - Core compositor settings
- `modules/hyprland/appearance.nix` - Visual styling
- `modules/hyprland/window-rules.nix` - Window behavior rules

**Actual config directory**: `~/.config/hypr/`

**Influenced by**: [omarchy](https://github.com/basecamp/omarchy)
keyboard-first workflow and aesthetic design

---

## Additional Resources

- **Hyprland Wiki**: <https://wiki.hyprland.org>
- **Omarchy Manual**:
  <https://learn.omacom.io/2/the-omarchy-manual>
- **Project Documentation**: See `docs/reference/` for architecture and
  development guides
