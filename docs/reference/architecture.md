# Nilfheim Architecture Reference

This document provides detailed information about the Nilfheim NixOS configuration architecture, module organization, and development patterns.

## Project Architecture

### Overview

- **Base:** Flake-parts with automatic module loading via `import-tree`
- **Pattern:** Aspect-oriented configuration (dendritic)
- **Organization:** Feature modules, aggregators, host-specific configs

### Directory Structure

```
nilfheim/
├── flake.nix                    # Entry point (minimal, just dependencies)
├── modules/
│   ├── flake/                   # Flake-parts configuration
│   ├── nilfheim/                # Custom project options (+user.nix, +theme.nix)
│   ├── hosts/                   # Host-specific configurations
│   │   └── {hostname}/          # Per-host modules
│   ├── lib/                     # Custom library functions
│   ├── nixos/                   # NixOS-specific modules (networking, nix, ssh, etc.)
│   ├── darwin/                  # macOS-specific modules (darwin.nix, homebrew.nix, zsh.nix)
│   ├── desktop/                 # Desktop environment and GUI applications
│   │   ├── desktop.nix          # Platform-specific desktop aggregator
│   │   ├── theme.nix            # Stylix theming with base function pattern
│   │   └── *.nix                # Desktop apps (alacritty, firefox, vscode, spotify, etc.)
│   ├── {feature}/               # Feature-specific modules (neovim/, hyprland/, waybar/, walker/)
│   └── {aspect}.nix             # Root-level aspect modules (audio.nix, starship.nix, zsh.nix, etc.)
└── secrets/                     # Secrets management
```

### Module Categories

1. **NixOS Modules:** `flake.modules.nixos.*` - System-level configuration
2. **Darwin Modules:** `flake.modules.darwin.*` - macOS system configuration
3. **Generic Modules:** `flake.modules.home.*` - Cross-platform user configuration (home-manager)
4. **Flake Options:** `flake.nilfheim.*` - Project-wide settings

### Key Concepts

- **Aspect Modules:** Each `.nix` file configures one aspect across multiple contexts
- **Aggregators:** Modules that import related features (e.g., `desktop.nix`)
- **No Manual Imports:** `import-tree` auto-loads modules; file location = documentation
- **Git-Tracked Files Only:** `import-tree` only loads files tracked by git - **always `git add` new files immediately**

---

## Import-Tree Behavior

This project uses `import-tree` for automatic module discovery. Understanding how it works is **critical** for successful development.

### How Import-Tree Works

`import-tree` automatically loads all `.nix` files from the `modules/` directory **that are tracked by git**. This means:

1. ✅ **Tracked files** (staged or committed) → Loaded by the flake
2. ❌ **Untracked files** (not added to git) → **Invisible to the flake**

### Required Workflow for New Files

**Every time you create a new `.nix` file, you MUST:**

```bash
# 1. Create the file (using Write tool)
# 2. IMMEDIATELY add it to git
git add modules/path/to/new-file.nix

# 3. NOW the flake can see it
nix flake check --impure  # Will work now
```

### Common Mistake

```bash
# ❌ WRONG - This will fail silently
Write modules/lib/helper.nix
# ... file created but not git-added
nix flake check  # ERROR: flake.lib defined multiple times
                 # (because import-tree didn't load helper.nix!)

# ✅ CORRECT
Write modules/lib/helper.nix
git add modules/lib/helper.nix
nix flake check  # SUCCESS - import-tree can now see the file
```

### Why This Matters

- `import-tree` uses git's index to discover files
- Untracked files are intentionally ignored (allows for drafts, backups with `_` prefix, etc.)
- **Symptom:** "file not found", "option defined multiple times", or missing functionality
- **Solution:** Always `git add` new files immediately after creation

### Files That Don't Need Git Add

- Files you're modifying (already tracked)
- Files prefixed with `_` (intentionally excluded)
- Non-`.nix` files (not loaded by import-tree)

---

## Development Rules

### Rule 1: Aspect-Oriented Naming

- ✓ Name files by **purpose/feature**, not implementation
- ✓ Examples: `ai-integration.nix`, `development-tools.nix`, `wayland-clipboard.nix`
- ✗ Avoid: `my-laptop.nix`, `package-list.nix`, `freya-specific.nix`

### Rule 2: Module Placement

Choose the right location:

| Type | Location | Example |
|------|----------|---------|
| Simple aspect | `modules/{name}.nix` | `modules/ssh.nix` |
| Complex feature | `modules/{feature}/` | `modules/nixvim/lsp.nix` |
| Host-specific | `modules/hosts/{hostname}/` | `modules/hosts/freya/hardware.nix` |
| Project option | `modules/nilfheim/+{name}.nix` | `modules/nilfheim/+user.nix` |
| Helper functions | `modules/lib/{name}.nix` | `modules/lib/nixvim.nix` |
| Desktop apps | `modules/desktop/` | `modules/desktop/firefox.nix` |
| Desktop aggregator | `modules/desktop/desktop.nix` | Platform-specific desktop setup |
| Theme config | `modules/desktop/theme.nix` | Stylix with base function pattern |
| macOS-specific | `modules/darwin/` | `modules/darwin/darwin.nix` |
| Platform packages | `modules/{platform}/packages.nix` | `modules/hyprland/packages.nix` |
| System shell setup | `modules/{nixos,darwin}/zsh.nix` | `modules/nixos/zsh.nix` |

### Rule 3: Aggregator Pattern

For related features that are commonly used together:
1. Create individual feature modules first
2. Create an aggregator that imports them
3. Example: `desktop.nix` aggregates desktop setup with platform-specific imports

```nix
# Good: platform-specific desktop aggregator
flake.modules.nixos.desktop = {
  imports = with inputs.self.modules.nixos; [
    hyprland  # Window manager (system-level)
    greetd    # Display manager
  ];

  # Platform-specific home imports
  home-manager.users.${username}.imports = with inputs.self.modules.home; [
    desktop      # Cross-platform GUI apps
    webapps      # Web apps with keybinds
    xdg          # XDG/MIME config (Linux-only)
    hyprland     # Hyprland user config
    waybar       # Status bar
    walker       # App launcher
    swayosd      # OSD
  ];
};

# Darwin desktop aggregator (cross-platform only)
flake.modules.darwin.desktop = {
  home-manager.users.${username}.imports = with inputs.self.modules.home; [
    desktop      # Same cross-platform GUI apps
    # No Linux-specific modules
  ];
};

# Generic desktop aggregator (cross-platform GUI apps)
flake.modules.home.desktop.imports = with inputs.self.modules.home; [
  firefox
  chromium
  vscode
  alacritty
  # ... other cross-platform apps
];
```

**Note:** Platform-specific aggregators (`nixos.desktop`, `darwin.desktop`) handle platform-specific imports internally. This allows hosts to simply import `desktop` and get the appropriate setup for their platform.

**Best Practice Example: Modular Feature Organization**

The `modules/neovim/` directory demonstrates excellent modular structure for complex features:

```
modules/neovim/
├── core.nix           # Core editor settings and options
├── keymaps.nix        # Keyboard shortcuts and bindings
├── lsp.nix            # Language server configuration
├── languages.nix      # Language-specific settings (Nix, Python, etc.)
├── telescope.nix      # Fuzzy finder configuration
├── git.nix            # Git integration (gitsigns)
├── terminal.nix       # Terminal integration (toggleterm, lazygit)
├── filetree.nix       # File explorer (NeoTree)
├── grug-far.nix       # Search and replace
├── tmux-navigator.nix # Vim-tmux navigation integration
├── diagnostics.nix    # Diagnostics and error display
├── ui.nix             # UI components
├── visuals.nix        # Visual enhancements
├── editor.nix         # Editor behavior
├── navigation.nix     # Navigation features
├── completion.nix     # Completion engine
├── treesitter.nix     # Syntax highlighting
└── mini.nix           # Mini.nvim suite
```

**Why this structure works well:**

1. **Single Responsibility:** Each file configures one specific aspect (LSP, git, telescope, etc.)
2. **Easy to Navigate:** Finding configuration is intuitive - LSP settings in `lsp.nix`, git in `git.nix`
3. **Self-Documenting:** File names clearly indicate what each module does
4. **Composable:** Features can be enabled/disabled independently
5. **Maintainable:** Changes to one feature don't affect others
6. **Scalable:** New features (like `grug-far.nix`) can be added without refactoring

**When to use this pattern:**

- Complex features with multiple sub-components (editor, compositor, media stack)
- When configuration for a single feature would exceed ~200 lines
- When different aspects have distinct concerns (keybindings vs. LSP vs. languages)
- When you want team members to easily find and modify specific functionality

**Contrast with anti-pattern:**

```nix
# ❌ BAD: monolithic file
modules/neovim.nix  # 2000+ lines of all neovim config

# ✅ GOOD: modular directory
modules/neovim/lsp.nix        # 150 lines focused on LSP
modules/neovim/keymaps.nix    # 150 lines focused on keybindings
modules/neovim/languages.nix  # 40 lines focused on language support
```

### Rule 4: Multi-Context Configuration

When a feature needs configuration at multiple levels:

**Shell configuration example:**
```nix
# System-level: modules/nixos/zsh.nix
{ inputs, ... }: let
  inherit (inputs.self.nilfheim.user) username;
in {
  flake.modules.nixos.zsh = {pkgs, ...}: {
    programs.zsh.enable = true;
    users.users.${username}.shell = pkgs.zsh;
  };
}

# User-level: modules/zsh.nix
_: {
  flake.modules.home.zsh = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
    };
  };
}
```

**Desktop configuration example:**
```nix
# One file, multiple platform contexts
{ inputs, ... }: let
  inherit (inputs.self.nilfheim.user) username;
in {
  # NixOS desktop (with Linux-specific tools)
  flake.modules.nixos.desktop = {
    imports = with inputs.self.modules.nixos; [
      hyprland
      greetd
    ];

    home-manager.users.${username}.imports = with inputs.self.modules.home; [
      desktop webapps xdg hyprland waybar walker swayosd
    ];
  };

  # Darwin desktop (cross-platform only)
  flake.modules.darwin.desktop = {
    home-manager.users.${username}.imports = with inputs.self.modules.home; [
      desktop  # Same cross-platform apps
    ];
  };

  # Generic cross-platform desktop apps
  flake.modules.home.desktop = {
    imports = with inputs.self.modules.home; [
      firefox chromium vscode alacritty
    ];
  };
}
```

### Rule 5: Custom Options

Use `flake.nilfheim.*` for project-wide settings:

```nix
# Define in modules/nilfheim/+feature.nix
options.flake.nilfheim.feature = {
  setting = lib.mkOption { ... };
};

# Reference in other modules
config.flake.modules.nixos.something = {
  value = config.flake.nilfheim.feature.setting;
};
```

### Rule 6: Theme Base Function Pattern

For platform-specific configuration with shared settings, use the base function pattern:

```nix
# modules/desktop/theme.nix
{ inputs, ... }: let
  inherit (inputs.self.nilfheim) theme;

  # Extract common configuration into a base function
  base = pkgs: {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.base16}.yaml";
    opacity.terminal = 0.95;
    fonts.monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
  };
in {
  # NixOS-specific configuration
  flake.modules.nixos.desktop = {pkgs, ...}: {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = base pkgs // {
      # Linux-specific theming
      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
      };
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
    };
  };

  # Darwin-specific configuration
  flake.modules.darwin.desktop = {pkgs, ...}: {
    imports = [inputs.stylix.darwinModules.stylix];
    stylix = base pkgs;  # Uses base settings only
  };
}
```

**Benefits:**
- Shared settings defined once in the `base` function
- Platform-specific customizations added via attribute merging (`//`)
- Clear separation of common vs platform-specific configuration
- Easy to maintain and update shared settings

**When to use:**
- Platform-specific modules that share most configuration
- Theme/styling configuration that varies slightly by platform
- Any configuration where you want to avoid duplication

### Rule 7: Avoid Manual Imports

- ✗ DO NOT add imports in `flake.nix`
- ✓ DO let `import-tree` discover modules automatically
- ✓ DO use file organization as documentation
- ✓ DO `git add` new files immediately after creation

**IMPORTANT:** `import-tree` only discovers files that are tracked by git. After creating any new `.nix` file, you MUST run:
```bash
git add path/to/new-file.nix
```

Without `git add`, the new file will not be loaded by the flake, causing evaluation errors or missing functionality.

---

## Cross-Platform Architecture

Nilfheim supports multiple platforms (NixOS, Darwin/macOS) through clear separation of platform-specific and cross-platform modules.

### Platform Categories

**Cross-Platform Modules** (`flake.modules.home.*`) - Work on any platform:
- `modules/desktop/` - GUI applications (Firefox, VS Code, Alacritty, Spotify, etc.)
- `modules/neovim/` - Editor configuration
- `modules/utilities/` - CLI tools (git, fzf, bat, etc.)
- User-level shell config (`zsh.nix`, `starship.nix`)

**Linux-Specific Modules** (`flake.modules.nixos.*`):
- `modules/hyprland/` - Hyprland window manager configuration
- `modules/waybar/` - Waybar status bar (top-level, flattened)
- `modules/walker/` - Walker application launcher (top-level, flattened)
- `modules/nixos/` - NixOS system configuration (networking, nix, ssh, home-manager)
- `modules/desktop/webapps.nix` - Web apps with Hyprland keybinds
- `modules/desktop/xdg.nix` - XDG/MIME configuration
- System-level shell setup (`modules/nixos/zsh.nix`)

**Darwin-Specific Modules** (`flake.modules.darwin.*`):
- `modules/darwin/` - macOS system defaults, Homebrew, and home-manager
- System-level shell setup (`modules/darwin/zsh.nix`)

### Design Principles

1. **Separation of Concerns:**
   - Desktop apps (Firefox, Alacritty) belong in `desktop/` (cross-platform)
   - Wayland-specific tools (waybar, walker) belong in `wayland/` (Linux-only)
   - Window manager config (Hyprland) stays separate from desktop apps
   - Shell configuration split: system-level (`nixos.zsh`/`darwin.zsh`) and user-level (`generic.zsh`)

2. **Platform-Specific Aggregators:**
   - `nixos.desktop` and `darwin.desktop` handle platform-specific desktop setup
   - They internally import appropriate home-manager modules for their platform
   - Hosts just import `desktop` and get the right configuration automatically

3. **Platform-Specific Packages:**
   - Helper scripts that depend on platform-specific tools (like `uwsm` for Wayland) should be defined in platform-specific modules
   - Example: `modules/hyprland/packages.nix` contains launch-* scripts that use Wayland session management

4. **Simplified Host Composition:**
   - Home-manager enabled by default on all systems (nixos + darwin)
   - Hosts import aggregators (`desktop`, `utilities`) or individual modules
   - Platform logic handled internally by aggregators

5. **Organized Module Structure:**
   - Single-file modules that were previously nested are now at top-level (e.g., `modules/audio.nix`, `modules/starship.nix`)
   - GUI applications grouped in `modules/desktop/` directory alongside desktop configuration
   - Platform-specific directories use explicit names (`nixos` instead of `system`)
   - Theme configuration uses extracted `base` function pattern for shared settings

### Example: Multi-Platform Configuration

**Linux workstation (freya):**
```nix
# System-level (NixOS)
flake.modules.nixos.freya = {
  imports = with inputs.self.modules.nixos; [
    desktop          # Includes Hyprland, Wayland tools, and home config
    zsh              # System-level zsh setup
    # ... other system modules
  ];
};

# User-level (home-manager)
flake.modules.home.freya = {
  imports = with inputs.self.modules.home; [
    utilities        # CLI tools + aliases
    zsh              # User zsh config
    starship         # Prompt customization
    neovim           # Editor
  ];
};
```

**macOS workstation (odin):**
```nix
# System-level (Darwin)
flake.modules.darwin.odin = {
  imports = with inputs.self.modules.darwin; [
    zsh              # System-level zsh for macOS
    # darwin.desktop when implemented
  ];
};

# User-level (home-manager)
flake.modules.home.odin = {
  imports = with inputs.self.modules.home; [
    utilities        # Same CLI tools as Linux
    zsh              # Same user zsh config
    starship         # Same prompt
    neovim           # Same editor
  ];
};
```

**Server (thor):**
```nix
# System-level (NixOS)
flake.modules.nixos.thor = {
  imports = with inputs.self.modules.nixos; [
    zsh              # System-level zsh
    # ... server-specific modules
  ];
};

# User-level (home-manager)
flake.modules.home.thor = {
  imports = with inputs.self.modules.home; [
    # Selective CLI utilities only (no shell customization)
    utilities        # Or individual tools: git, fzf, bat, eza, etc.
  ];
};
```

### Benefits

- **Desktop apps work everywhere** - No Wayland/Hyprland dependencies in cross-platform modules
- **No build failures** - Platform-specific packages isolated to their respective modules
- **Easy to add platforms** - New platforms (Raspberry Pi, etc.) can selectively import modules
- **Flexible composition** - Servers can import CLI tools without shell customization
- **Simplified host configs** - Home-manager enabled by default, aggregators handle platform logic
- **Clear separation** - System shell setup separate from user shell customization

---

## Resources

- **Dendritic Principles:** https://vic.github.io/dendrix/Dendritic.html
- **Flake Parts:** https://flake.parts
- **Reference Configs:**
  - https://github.com/vic/dendrix
  - https://github.com/GaetanLepage/nix-config
