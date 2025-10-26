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
│   ├── {feature}/               # Feature-specific modules (nixvim/, hyprland/, waybar/)
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

### Rule 3: Aggregator Pattern

For related features that are commonly used together:
1. Create individual feature modules first
2. Create an aggregator that imports them
3. Example: `desktop.nix` aggregates `hyprland`, `greetd`, `nixvim`, `waybar`

```nix
# Good: aggregator pattern
flake.modules.nixos.desktop.imports = with inputs.self.modules.nixos; [
  hyprland
  greetd
];
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

## Resources

- **Dendritic Principles:** https://vic.github.io/dendrix/Dendritic.html
- **Flake Parts:** https://flake.parts
- **Reference Configs:**
  - https://github.com/vic/dendrix
  - https://github.com/GaetanLepage/nix-config
