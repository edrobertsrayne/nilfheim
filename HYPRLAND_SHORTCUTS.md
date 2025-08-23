# Hyprland Keyboard Shortcuts

This document contains all keyboard shortcuts configured for the Hyprland window manager in this NixOS configuration.

**Note:** `Super` refers to the Windows/Cmd key.

## 🚀 Applications

| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + Enter` | Launch Terminal | Opens foot terminal |
| `Super + Space` | App Launcher | Opens rofi application launcher |
| `Super + B` | Launch Browser | Opens Firefox browser |
| `Super + R` | App Launcher | Opens rofi application launcher (alternative) |
| `Super + E` | File Manager | Opens Nautilus file manager |
| `Super + Shift + E` | Alternative File Manager | Opens Thunar file manager |
| `Super + L` | Lock Screen | Activates hyprlock screen locker |
| `Super + Shift + C` | Clipboard History | Shows clipboard history with rofi |

## 🔧 System Utilities

| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + A` | Audio Control | Opens PulseAudio volume control |
| `Super + Shift + B` | Bluetooth Manager | Opens Blueman bluetooth manager |
| `Super + Shift + N` | Network Manager | Opens NetworkManager connection editor |
| `Super + Shift + D` | Discord | Launches Discord |

## 🎨 Media & Graphics

| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + Shift + V` | VLC Player | Launches VLC media player |
| `Super + Shift + G` | GIMP | Opens GIMP image editor |
| `Super + Shift + I` | Inkscape | Opens Inkscape vector graphics editor |

## 🪟 Window Management

| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + Q` | Close Window | Kills the active window |
| `Super + M` | Exit Hyprland | Exits the window manager |
| `Super + V` | Toggle Float | Toggles floating mode for active window |
| `Super + F` | Fullscreen | Toggles fullscreen mode |
| `Super + P` | Pseudo Tiling | Enables pseudo-tiling mode |
| `Super + J` | Toggle Split | Toggles split direction |

## 🧭 Focus Navigation

### Arrow Keys
| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + Left` | Focus Left | Moves focus to left window |
| `Super + Right` | Focus Right | Moves focus to right window |
| `Super + Up` | Focus Up | Moves focus to upper window |
| `Super + Down` | Focus Down | Moves focus to lower window |

### Vim-style Keys
| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + H` | Focus Left | Moves focus to left window |
| `Super + L` | Focus Right | Moves focus to right window |
| `Super + K` | Focus Up | Moves focus to upper window |
| `Super + J` | Focus Down | Moves focus to lower window |

## 🖥️ Workspace Management

### Switch Workspaces
| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + 1` | Workspace 1 | Switch to workspace 1 (General) |
| `Super + 2` | Workspace 2 | Switch to workspace 2 (Graphics/Design) |
| `Super + 3` | Workspace 3 | Switch to workspace 3 (Media) |
| `Super + 4` | Workspace 4 | Switch to workspace 4 (Communication) |
| `Super + 5` | Workspace 5 | Switch to workspace 5 |
| `Super + 6` | Workspace 6 | Switch to workspace 6 |
| `Super + 7` | Workspace 7 | Switch to workspace 7 |
| `Super + 8` | Workspace 8 | Switch to workspace 8 |
| `Super + 9` | Workspace 9 | Switch to workspace 9 |
| `Super + 0` | Workspace 10 | Switch to workspace 10 |

### Move Windows to Workspaces
| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + Shift + 1` | Move to Workspace 1 | Move active window to workspace 1 |
| `Super + Shift + 2` | Move to Workspace 2 | Move active window to workspace 2 |
| `Super + Shift + 3` | Move to Workspace 3 | Move active window to workspace 3 |
| `Super + Shift + 4` | Move to Workspace 4 | Move active window to workspace 4 |
| `Super + Shift + 5` | Move to Workspace 5 | Move active window to workspace 5 |
| `Super + Shift + 6` | Move to Workspace 6 | Move active window to workspace 6 |
| `Super + Shift + 7` | Move to Workspace 7 | Move active window to workspace 7 |
| `Super + Shift + 8` | Move to Workspace 8 | Move active window to workspace 8 |
| `Super + Shift + 9` | Move to Workspace 9 | Move active window to workspace 9 |
| `Super + Shift + 0` | Move to Workspace 10 | Move active window to workspace 10 |

### Special Workspace (Scratchpad)
| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + S` | Toggle Scratchpad | Toggle special workspace visibility |
| `Super + Shift + S` | Move to Scratchpad | Move active window to scratchpad |

### Mouse Workspace Navigation
| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + Mouse Wheel Down` | Next Workspace | Switch to next workspace |
| `Super + Mouse Wheel Up` | Previous Workspace | Switch to previous workspace |

## 📸 Screenshots

### grim + slurp + swappy (Interactive)
| Shortcut | Action | Description |
|----------|---------|-------------|
| `Print` | Region Screenshot | Select region and edit with swappy |
| `Super + Print` | Full Screenshot | Capture entire screen, edit with swappy |
| `Super + Shift + S` | Region to File | Select region, save directly to file |
| `Super + Shift + Print` | Full Screen to File | Capture entire screen to file |
| `Super + Alt + Print` | Region to Clipboard | Select region, copy to clipboard |

### hyprshot (Hyprland Optimized)
| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + Ctrl + Print` | Output Screenshot | Capture current monitor output |
| `Super + Ctrl + S` | Region Screenshot | Capture selected region |
| `Super + Ctrl + Shift + S` | Window Screenshot | Capture active window |

## 🔊 Audio Controls

| Shortcut | Action | Description |
|----------|---------|-------------|
| `Volume Up Key` | Increase Volume | Raise volume by 5% |
| `Volume Down Key` | Decrease Volume | Lower volume by 5% |
| `Mute Key` | Toggle Mute | Mute/unmute audio |

## 🔅 Brightness Controls

| Shortcut | Action | Description |
|----------|---------|-------------|
| `Brightness Up Key` | Increase Brightness | Raise screen brightness by 5% |
| `Brightness Down Key` | Decrease Brightness | Lower screen brightness by 5% |

## ⏯️ Media Controls

| Shortcut | Action | Description |
|----------|---------|-------------|
| `Play/Pause Key` | Play/Pause | Toggle media playback |
| `Next Track Key` | Next Track | Skip to next media track |
| `Previous Track Key` | Previous Track | Go to previous media track |

## 🖱️ Mouse Bindings

| Shortcut | Action | Description |
|----------|---------|-------------|
| `Super + Left Click + Drag` | Move Window | Drag to move floating windows |
| `Super + Right Click + Drag` | Resize Window | Drag to resize windows |

## 📁 Workspace Layout

The workspaces are organized thematically:

- **Workspace 1**: General workspace (default)
- **Workspace 2**: Graphics/Design (GIMP, Inkscape auto-assigned)
- **Workspace 3**: Media (VLC auto-assigned)
- **Workspace 4**: Communication (Discord auto-assigned)
- **Workspaces 5-10**: General purpose

## 💡 Tips

1. **Quick Launch**: `Super + Space` is the fastest way to launch applications
2. **Browser Access**: `Super + B` for instant Firefox access
3. **Floating Windows**: Use `Super + V` to toggle floating mode for any window
4. **Quick Access**: The scratchpad (`Super + S`) is great for temporary windows
5. **Screenshots**: Use the interactive screenshot tools for quick editing
6. **Focus**: Both arrow keys and vim-style navigation (hjkl) work for focus movement
7. **Efficiency**: Mouse wheel navigation with Super key for quick workspace switching

---

*Generated from Hyprland configuration - keep this file updated when shortcuts change*