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
│   ├── darwin/                  # macOS-specific modules (macos.nix, homebrew.nix)
│   ├── wayland/                 # Wayland-specific modules (waybar/, walker/, swayosd.nix)
│   ├── {feature}/               # Feature-specific modules (nixvim/, hyprland/, desktop/)
│   └── {aspect}.nix             # Root-level aspect modules (ssh.nix, nix.nix, etc.)
└── secrets/                     # Secrets management
```

### Module Categories

1. **NixOS Modules:** `flake.modules.nixos.*` - System-level configuration
2. **Home-Manager Modules:** `flake.modules.homeManager.*` - User-level configuration
3. **Flake Options:** `flake.nilfheim.*` - Project-wide settings

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
| Wayland-specific | `modules/wayland/` | `modules/wayland/waybar/` |
| macOS-specific | `modules/darwin/` | `modules/darwin/macos.nix` |
| Platform packages | `modules/{platform}/packages.nix` | `modules/hyprland/packages.nix` |

### Rule 3: Aggregator Pattern

For related features that are commonly used together:
1. Create individual feature modules first
2. Create an aggregator that imports them
3. Example: `desktop.nix` aggregates cross-platform tools like `neovim` and `utilities`

```nix
# Good: aggregator pattern (cross-platform tools only)
flake.modules.nixos.desktop.imports = with inputs.self.modules.nixos; [
  hyprland  # Window manager (system-level)
  greetd    # Display manager
];

flake.modules.homeManager.desktop.imports = with inputs.self.modules.homeManager; [
  neovim     # Cross-platform editor
  utilities  # Cross-platform CLI tools
];
```

**Note:** Aggregators should group related aspects, but avoid mixing platform-specific modules (like Wayland tools) with cross-platform modules. Host configurations explicitly compose platform-specific modules as needed.

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

When a feature needs both NixOS and Home-Manager config:

```nix
# Good: one file, multiple contexts
{ inputs, ... }: {
  flake.modules.nixos.myFeature = {
    # NixOS system config
    services.myService.enable = true;
  };

  flake.modules.homeManager.myFeature = {
    # Home-manager user config
    programs.myProgram.enable = true;
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

### Rule 6: Avoid Manual Imports

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

**Cross-Platform Modules** - Work on any platform:
- `modules/desktop/` - GUI applications (Firefox, VS Code, etc.)
- `modules/neovim/` - Editor configuration
- `modules/utilities/` - CLI tools (git, fzf, bat, etc.)

**Linux-Specific Modules:**
- `modules/hyprland/` - Hyprland window manager configuration
- `modules/wayland/` - Wayland compositor tools (waybar, walker, swayosd)
- `modules/system/` - NixOS system configuration (networking, nix, ssh)

**Darwin-Specific Modules:**
- `modules/darwin/` - macOS system defaults and Homebrew

### Design Principles

1. **Separation of Concerns:**
   - Desktop apps (Firefox, Alacritty) belong in `desktop/` (cross-platform)
   - Wayland-specific tools (waybar, walker) belong in `wayland/` (Linux-only)
   - Window manager config (Hyprland) stays separate from desktop apps

2. **Platform-Specific Packages:**
   - Helper scripts that depend on platform-specific tools (like `uwsm` for Wayland) should be defined in platform-specific modules
   - Example: `modules/hyprland/packages.nix` contains launch-* scripts that use Wayland session management

3. **Explicit Host Composition:**
   - Hosts explicitly import the modules they need
   - Linux hosts import: `desktop`, `wayland`, `hyprland`
   - Darwin hosts import: `desktop`, `darwin`

### Example: Multi-Platform Configuration

**Linux workstation (freya):**
```nix
flake.modules.homeManager.freya = {
  imports = with inputs.self.modules.homeManager; [
    utilities   # Cross-platform CLI tools
    desktop     # Cross-platform GUI apps
    hyprland    # Linux window manager
    waybar      # Wayland status bar
    walker      # Wayland launcher
    swayosd     # Wayland OSD
  ];
};
```

**macOS workstation (odin):**
```nix
flake.modules.homeManager.odin = {
  imports = with inputs.self.modules.homeManager; [
    utilities   # Same CLI tools as Linux
    desktop     # Same GUI apps as Linux
    # No wayland/hyprland - use darwin-specific tools instead
  ];
};
```

**Server (thor):**
```nix
flake.modules.homeManager.thor = {
  imports = with inputs.self.modules.homeManager; [
    # Selective CLI utilities only (no shell customization)
    git
    fzf
    bat
    eza
    lazygit
    lazydocker
  ];
};
```

### Benefits

- **Desktop apps work everywhere** - No Wayland/Hyprland dependencies in cross-platform modules
- **No build failures** - Platform-specific packages isolated to their respective modules
- **Easy to add platforms** - New platforms (Raspberry Pi, etc.) can selectively import modules
- **Flexible composition** - Servers can import CLI tools without shell customization

---

## Resources

- **Dendritic Principles:** https://vic.github.io/dendrix/Dendritic.html
- **Flake Parts:** https://flake.parts
- **Reference Configs:**
  - https://github.com/vic/dendrix
  - https://github.com/GaetanLepage/nix-config
