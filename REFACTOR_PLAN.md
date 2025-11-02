# Module Organization Refactor Plan

**Branch:** `refactor/module-organisation`

**Goal:** Reorganize module structure to support platform-specific desktop configurations while maintaining aspect-oriented organization.

---

## Overview of Changes

### Key Objectives
1. **Rename `homeManager` → `home`** throughout entire codebase
2. **Enable home-manager by default** on all systems (nixos + darwin)
3. **Reorganize shell configuration** into separate system/user modules (zsh, starship)
4. **Create desktop aggregator** with platform-specific sections (nixos.desktop, darwin.desktop, home.desktop)
5. **Consolidate web apps** with co-located keybinds into `flake.modules.home.webapps`
6. **Separate XDG config** into `flake.modules.home.xdg` (Linux-only)
7. **Update host configurations** to use new simplified structure
8. **Move aliases** into appropriate modules (neovim, utilities)

---

## Phase 1: Setup & Preparation

### Tasks
- [ ] Create branch `refactor/module-organisation`
- [ ] Verify clean working state
- [ ] Document current module count (baseline: 139 .nix files)
- [ ] Read this plan thoroughly

### Commands
```bash
git checkout -b refactor/module-organisation
git status
find modules -name "*.nix" | wc -l
```

### Commit
- **None** (preparation only)

---

## Phase 2: Core Rename (homeManager → home)

**Goal:** Rename all `homeManager` references to `home` throughout codebase.

### Files to Update

#### A. Flake-level module definitions (define flake.modules.home.*)
- [ ] `modules/utilities/*.nix` (25 files) - Change `flake.modules.homeManager.*` → `flake.modules.home.*`
- [ ] `modules/desktop/*.nix` (~25 files) - Change `flake.modules.homeManager.desktop` → `flake.modules.home.desktop`
- [ ] `modules/neovim/*.nix` (~18 files) - Change `flake.modules.homeManager.*` → `flake.modules.home.*`
- [ ] `modules/wayland/*.nix` (waybar, walker, swayosd) - Change to `flake.modules.home.*`
- [ ] `modules/hyprland/*.nix` (~15 files) - Change to `flake.modules.home.*`
- [ ] `modules/media/*.nix` - Change to `flake.modules.home.*`
- [ ] `modules/services/*.nix` - Check for home-manager modules, rename if needed

#### B. Host configurations (reference flake.modules.home.*)
- [ ] `modules/hosts/freya/freya.nix` - Change `flake.modules.homeManager.freya` → `flake.modules.home.freya`
- [ ] `modules/hosts/thor/thor.nix` - Change `flake.modules.homeManager.thor` → `flake.modules.home.thor`
- [ ] `modules/hosts/odin.nix` - Change `flake.modules.homeManager.odin` → `flake.modules.home.odin`

#### C. Imports/references (consume flake.modules.home.*)
- [ ] `modules/desktop/imports.nix` - Update imports from `modules.homeManager` → `modules.home`
- [ ] `modules/system/home-manager.nix` - Update line 17 and 48: `inputs.self.modules.homeManager` → `inputs.self.modules.home`
- [ ] `modules/darwin/homebrew.nix` - Check for references
- [ ] `modules/lib/hosts.nix` - Update references in helper functions

#### D. Verification
- [ ] Search entire codebase for remaining `homeManager` references: `grep -r "homeManager" modules/`
- [ ] Ensure only `modules/system/home-manager.nix` (the file name) remains

### Quality Checks
```bash
# After all renames
alejandra --check .
statix check .
deadnix --fail .
nix flake check --impure
```

### Commit
```
refactor(modules): rename homeManager to home throughout codebase

- Rename flake.modules.homeManager.* to flake.modules.home.*
- Update all module definitions and imports
- Update host configurations to reference home modules
- Simplify naming convention for better clarity

This is a pure rename with no functional changes.
```

---

## Phase 3: System Defaults

**Goal:** Enable home-manager by default on all systems, rename macos.nix → darwin.nix

### Tasks

#### A. Enable home-manager on NixOS by default
- [ ] Update `modules/system/nixos.nix` to import home-manager module
- [ ] Remove home-manager import from individual host configs (if any)

**Change:**
```nix
# modules/system/nixos.nix
_: {
  flake.modules.nixos.nixos = {
    imports = [ inputs.self.modules.nixos.home-manager ];
    system.stateVersion = "25.05";
  };
}
```

#### B. Rename macos.nix → darwin.nix
- [ ] `git mv modules/darwin/macos.nix modules/darwin/darwin.nix`
- [ ] Update module definition from `flake.modules.darwin.darwin` (no change needed)
- [ ] Verify import in lib/hosts.nix still works

#### C. Enable home-manager on Darwin by default
- [ ] Update `modules/darwin/darwin.nix` to import home-manager module
- [ ] Remove home-manager import from lib/hosts.nix darwin helper (line 29)

**Change:**
```nix
# modules/darwin/darwin.nix (renamed from macos.nix)
{inputs, ...}: {
  flake.modules.darwin.darwin = {
    imports = [ inputs.self.modules.darwin.home-manager ];
    # ... existing system defaults
  };
}
```

#### D. Update lib/hosts.nix
- [ ] Remove home-manager import from darwinSystem helper (now redundant)

### Quality Checks
```bash
alejandra --check .
statix check .
deadnix --fail .
nix flake check --impure
```

### Commit
```
feat(system): enable home-manager by default on all platforms

- Enable home-manager in base nixos.nixos module
- Enable home-manager in base darwin.darwin module
- Rename macos.nix → darwin.nix for consistency
- Simplify host configuration (no manual home-manager imports needed)

Every system now gets home-manager automatically.
```

---

## Phase 4: Shell Separation

**Goal:** Split shell configuration into platform (system-level) and user (home-level) modules.

### Tasks

#### A. Create system-level zsh modules

**Create `modules/system/zsh.nix`:**
```nix
{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  flake.modules.nixos.zsh = {pkgs, ...}: {
    programs.zsh.enable = true;
    users.users.${username}.shell = pkgs.zsh;
  };
}
```

**Create `modules/darwin/zsh.nix`:**
```nix
{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  flake.modules.darwin.zsh = {pkgs, ...}: {
    programs.zsh.enable = true;
    users.users.${username}.shell = pkgs.zsh;
  };
}
```

- [ ] Create `modules/system/zsh.nix`
- [ ] Create `modules/darwin/zsh.nix`
- [ ] `git add modules/system/zsh.nix modules/darwin/zsh.nix`

#### B. Create user-level shell modules

**Update `modules/utilities/zsh.nix`:**
```nix
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

**Create `modules/utilities/starship.nix`** (already exists, just verify):
```nix
_: {
  flake.modules.home.starship = {
    programs.starship.enable = true;
  };
}
```

- [ ] Verify `modules/utilities/zsh.nix` defines `flake.modules.home.zsh`
- [ ] Verify `modules/utilities/starship.nix` defines `flake.modules.home.starship`
- [ ] No changes needed if already correct

#### C. Remove shell config from system/home-manager.nix
- [ ] Remove `users.users."${username}".shell = pkgs.zsh;` from nixos section
- [ ] Remove `programs.zsh.enable = true;` from nixos section
- [ ] Remove `users.users."${username}".shell = pkgs.zsh;` from darwin section
- [ ] Remove `programs.zsh.enable = true;` from darwin section

**Result:** `modules/system/home-manager.nix` only sets up home-manager framework, no shell config.

#### D. Update host configurations
- [ ] `modules/hosts/freya/freya.nix` - Add `nixos.zsh` to nixos imports, add `home.zsh` and `home.starship` to home imports
- [ ] `modules/hosts/thor/thor.nix` - Add `nixos.zsh` to nixos imports, optionally add `home.zsh` (server may not need)
- [ ] `modules/hosts/odin.nix` - Add `darwin.zsh` to darwin imports (if darwin), add `home.zsh` to home imports

### Quality Checks
```bash
alejandra --check .
statix check .
deadnix --fail .
nix flake check --impure
```

### Commit
```
refactor(shell): separate system and user shell configuration

- Create nixos.zsh and darwin.zsh for system-level shell setup
- Keep home.zsh for user-level zsh configuration
- Keep home.starship separate (optional prompt customization)
- Remove shell setup from home-manager.nix (now opt-in per host)

This allows hosts to choose bash (default) or zsh explicitly.
```

---

## Phase 5: Desktop Aggregation

**Goal:** Create `modules/desktop/desktop.nix` with platform-specific desktop aggregators.

### Tasks

#### A. Create desktop aggregator

**Create `modules/desktop/desktop.nix`:**
```nix
{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  # NixOS desktop aggregator
  flake.modules.nixos.desktop = {
    imports = with inputs.self.modules.nixos; [
      hyprland
      greetd
    ];

    # Platform-specific home modules
    home-manager.users.${username}.imports = with inputs.self.modules.home; [
      desktop      # Cross-platform GUI apps
      webapps      # Web apps with keybinds
      xdg          # XDG/MIME config
      hyprland     # Hyprland user config
      waybar       # Status bar
      walker       # App launcher
      swayosd      # OSD
    ];
  };

  # Darwin desktop aggregator
  flake.modules.darwin.desktop = {
    imports = with inputs.self.modules.darwin; [
      # Darwin-specific imports if any
    ];

    # Cross-platform home modules only
    home-manager.users.${username}.imports = with inputs.self.modules.home; [
      desktop      # Same cross-platform GUI apps
      # No Linux-specific modules
    ];
  };

  # Cross-platform home desktop module (aggregator)
  flake.modules.home.desktop = {
    imports = with inputs.self.modules.home; [
      # All the existing desktop/* modules that are cross-platform
      # Will be populated from current modules/desktop/*.nix files
    ];
  };
}
```

- [ ] Create `modules/desktop/desktop.nix`
- [ ] `git add modules/desktop/desktop.nix`

#### B. Update existing modules/desktop/imports.nix
- [ ] This file currently does some aggregation - decide whether to delete or repurpose
- [ ] Likely delete since `desktop.nix` replaces it

#### C. Identify cross-platform desktop modules
Cross-platform modules (should be part of `flake.modules.home.desktop`):
- [ ] firefox.nix
- [ ] alacritty.nix
- [ ] obsidian.nix
- [ ] vscode.nix
- [ ] chromium.nix
- [ ] zathura.nix
- [ ] gtk.nix
- [ ] theme.nix
- [ ] audio.nix (if cross-platform)

These will be imported by the `home.desktop` aggregator in `desktop.nix`.

### Quality Checks
```bash
alejandra --check .
statix check .
deadnix --fail .
nix flake check --impure
```

### Commit
```
feat(desktop): create platform-specific desktop aggregators

- Add modules/desktop/desktop.nix with nixos.desktop and darwin.desktop
- NixOS desktop includes Hyprland, Wayland tools, and home config
- Darwin desktop includes cross-platform home config only
- Create home.desktop as aggregator for cross-platform GUI apps

Hosts can now import just nixos.desktop or darwin.desktop for full setup.
```

---

## Phase 6: Web Apps Consolidation

**Goal:** Create `flake.modules.home.webapps` with .desktop entries and keybinds co-located.

### Tasks

#### A. Create webapps aggregator

**Create `modules/desktop/webapps.nix`:**
```nix
{inputs, ...}: {
  flake.modules.home.webapps = {pkgs, lib, ...}: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
    launch-terminal = lib.getExe inputs.self.packages.${pkgs.system}.launch-terminal;
  in {
    # Desktop entries
    xdg.desktopEntries = {
      gmail = {
        name = "Gmail";
        comment = "Google Mail";
        exec = "${pkgs.firefox}/bin/firefox --new-window https://mail.google.com";
        icon = ./../assets/icons/gmail.png;
        categories = ["Office"];
        terminal = false;
        type = "Application";
      };
      # ... more web apps from individual files
    };

    # Hyprland keybinds (co-located!)
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, M, Gmail, exec, ${launch-webapp} \"https://mail.google.com\""
      "SUPER SHIFT, C, Google Calendar, exec, ${launch-webapp} \"https://calendar.google.com\""
      "SUPER SHIFT, Y, YouTube, exec, ${launch-webapp} \"https://youtube.com\""
      "SUPER SHIFT, N, NotebookLM, exec, ${launch-webapp} \"https://notebooklm.google.com\""
      "SUPER SHIFT, R, Readwise Reader, exec, ${launch-webapp} \"https://read.readwise.io\""
      "SUPER SHIFT, P, p5.js Editor, exec, ${launch-webapp} \"https://editor.p5js.org\""
      "SUPER SHIFT, G, Google Drive, exec, ${launch-webapp} \"https://drive.google.com\""
      "SUPER SHIFT, A, Open Claude webapp, exec, ${launch-webapp} \"https://claude.ai\""

      # Native applications
      "SUPER SHIFT, S, Spotify, exec, ${pkgs.spotify}/bin/spotify"
      "SUPER SHIFT, D, LazyDocker, exec, ${launch-terminal} -e lazydocker"
    ];
  };
}
```

- [ ] Create `modules/desktop/webapps.nix` consolidating all web apps
- [ ] Copy .desktop entries from: gmail.nix, youtube.nix, claude.nix, google-calendar.nix, google-drive.nix, notebooklm.nix, readwise.nix, p5js.nix
- [ ] Copy keybinds from `modules/hyprland/keybinds-webapps.nix`
- [ ] Copy native app keybinds (Spotify, LazyDocker) from keybinds-webapps.nix
- [ ] `git add modules/desktop/webapps.nix`

#### B. Remove old files
- [ ] `git rm modules/desktop/gmail.nix`
- [ ] `git rm modules/desktop/youtube.nix`
- [ ] `git rm modules/desktop/claude.nix`
- [ ] `git rm modules/desktop/google-calendar.nix`
- [ ] `git rm modules/desktop/google-drive.nix`
- [ ] `git rm modules/desktop/notebooklm.nix`
- [ ] `git rm modules/desktop/readwise.nix`
- [ ] `git rm modules/desktop/p5js.nix`
- [ ] `git rm modules/hyprland/keybinds-webapps.nix`

#### C. Handle spotify and lazydocker
These have both .desktop entries AND keybinds:
- [ ] Check `modules/desktop/spotify.nix` - merge keybind into it or move to webapps
- [ ] Check `modules/desktop/lazydocker.nix` - merge keybind into it or move to webapps

Decision: Move their keybinds into webapps.nix, keep their .desktop files separate (they're full apps, not just web wrappers).

#### D. Update desktop.nix aggregator
- [ ] Add `webapps` to the imports in `flake.modules.nixos.desktop` (Linux only)
- [ ] Do NOT add to `flake.modules.darwin.desktop` (has Hyprland keybinds)

### Quality Checks
```bash
alejandra --check .
statix check .
deadnix --fail .
nix flake check --impure
```

### Commit
```
refactor(desktop): consolidate web apps with co-located keybinds

- Create modules/desktop/webapps.nix with flake.modules.home.webapps
- Co-locate .desktop entries with their Hyprland keybinds
- Remove individual web app files (gmail, youtube, claude, etc.)
- Remove modules/hyprland/keybinds-webapps.nix (merged into webapps)

Each web app now has its .desktop entry and keybind in one place.
```

---

## Phase 7: XDG Separation

**Goal:** Extract XDG config into `flake.modules.home.xdg` (Linux-only).

### Tasks

#### A. Update modules/desktop/xdg.nix
Currently defines `flake.modules.home.desktop`, should define `flake.modules.home.xdg`:

```nix
{inputs, ...}: {
  flake.modules.home.xdg = {lib, ...}: let
    inherit (inputs.self.nilfheim.desktop) browser;

    # Map common browser commands to their .desktop file names
    browserDesktopFile = let
      mapping = {
        firefox = "firefox.desktop";
        chromium = "chromium-browser.desktop";
        brave = "brave-browser.desktop";
        google-chrome = "google-chrome.desktop";
        vivaldi = "vivaldi-stable.desktop";
        opera = "opera.desktop";
        microsoft-edge = "microsoft-edge.desktop";
        epiphany = "org.gnome.Epiphany.desktop";
        qutebrowser = "org.qutebrowser.qutebrowser.desktop";
      };
    in
      mapping.${browser} or "${browser}.desktop";

    # All MIME types that should be handled by the default browser
    browserMimeTypes = [
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
      "x-scheme-handler/chrome"
      "text/html"
      "application/x-extension-htm"
      "application/x-extension-html"
      "application/x-extension-shtml"
      "application/xhtml+xml"
      "application/x-extension-xhtml"
      "application/x-extension-xht"
    ];
  in {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = lib.genAttrs browserMimeTypes (_: browserDesktopFile);
    };
  };
}
```

- [ ] Update `modules/desktop/xdg.nix` to define `flake.modules.home.xdg` instead of `flake.modules.home.desktop`

#### B. Update desktop.nix aggregator
- [ ] Add `xdg` to imports in `flake.modules.nixos.desktop` (Linux only)
- [ ] Do NOT add to `flake.modules.darwin.desktop` (Linux-specific)

### Quality Checks
```bash
alejandra --check .
statix check .
deadnix --fail .
nix flake check --impure
```

### Commit
```
refactor(desktop): separate XDG configuration into standalone module

- Change modules/desktop/xdg.nix to define flake.modules.home.xdg
- Import only on Linux (nixos.desktop), not Darwin
- Keep MIME type and default application management separate

XDG is now a Linux-specific concern that can be imported selectively.
```

---

## Phase 8: Alias Migration

**Goal:** Move `n = "nvim"` alias to neovim module, keep other aliases in utilities.

### Tasks

#### A. Update modules/neovim/core.nix
Add shell alias to the neovim core module:

```nix
# Add to existing module
flake.modules.home.neovim = {
  # ... existing config

  home.shellAliases = {
    n = "nvim";
  };
};
```

- [ ] Update `modules/neovim/core.nix` to add `n` alias

#### B. Update modules/utilities/aliases.nix
Remove the `n` alias:

```nix
_: {
  flake.modules.home.utilities = {
    home = {
      shell.enableShellIntegration = true;
      shellAliases = {
        c = "clear";
        # n = "nvim";  # REMOVE - now in neovim module
        top = "btop";
        du = "ncdu";
      };
    };
  };
}
```

- [ ] Remove `n = "nvim";` from `modules/utilities/aliases.nix`

### Quality Checks
```bash
alejandra --check .
statix check .
deadnix --fail .
nix flake check --impure
```

### Commit
```
refactor(aliases): move nvim alias to neovim module

- Add 'n = "nvim"' alias to modules/neovim/core.nix
- Remove from modules/utilities/aliases.nix
- Keep aliases with their relevant aspects
```

---

## Phase 9: Host Configuration Updates

**Goal:** Update all host configs to use new simplified structure.

### Tasks

#### A. Update modules/hosts/freya/freya.nix

**Current:**
```nix
{inputs, ...}: {
  flake.modules.nixos.freya = {
    imports = with inputs.self.modules.nixos; [
      ./_disko.nix
      ./_hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s

      home-manager
      desktop
      nfs-client
      powerManagement
    ];

    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };

  flake.modules.homeManager.freya = {
    imports = with inputs.self.modules.homeManager; [
      utilities
      desktop
      hyprland
      waybar
      walker
      swayosd
    ];
  };
}
```

**New:**
```nix
{inputs, ...}: {
  flake.modules.nixos.freya = {
    imports = with inputs.self.modules.nixos; [
      ./_disko.nix
      ./_hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s

      desktop          # Includes all desktop + home config automatically
      zsh              # System-level zsh
      nfs-client
      powerManagement
    ];

    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };

  flake.modules.home.freya = {
    imports = with inputs.self.modules.home; [
      utilities        # CLI tools + aliases
      zsh              # User zsh config
      starship         # Prompt customization
      neovim           # Editor
    ];
  };
}
```

- [ ] Update `modules/hosts/freya/freya.nix`
- [ ] Remove `home-manager` import (now automatic)
- [ ] Add `zsh` to nixos imports
- [ ] Add `zsh`, `starship` to home imports
- [ ] Add `neovim` to home imports (make explicit)
- [ ] Remove individual Wayland imports (now in desktop aggregator)

#### B. Update modules/hosts/thor/thor.nix

**Current:**
```nix
{inputs, ...}: {
  flake.nilfheim.server.cloudflare = {
    tunnel = "23c4423f-ec30-423b-ba18-ba18904ddb85";
    secret = ../../../secrets/cloudflare-thor.age;
  };

  flake.modules.nixos.thor = {
    imports = with inputs.self.modules.nixos; [
      ./_disko.nix
      ./_hardware-configuration.nix

      portainer
      blocky
      media
      cloudflared
      home-assistant
    ];
    # ... rest of config
  };

  flake.modules.homeManager.thor = {
    imports = with inputs.self.modules.homeManager; [
      # CLI tools (no shell customization)
      git
      fzf
      bat
      eza
      fd
      lazygit
      lazydocker
      gh
      delta
      direnv
      jq
    ];
  };
}
```

**New:**
```nix
{inputs, ...}: {
  flake.nilfheim.server.cloudflare = {
    tunnel = "23c4423f-ec30-423b-ba18-ba18904ddb85";
    secret = ../../../secrets/cloudflare-thor.age;
  };

  flake.modules.nixos.thor = {
    imports = with inputs.self.modules.nixos; [
      ./_disko.nix
      ./_hardware-configuration.nix

      zsh              # System-level zsh (servers get zsh too!)
      portainer
      blocky
      media
      cloudflared
      home-assistant
    ];
    # ... rest of config
  };

  flake.modules.home.thor = {
    imports = with inputs.self.modules.home; [
      # Import individual tools without the utilities aggregator
      # This gives CLI tools without shell customization
      git
      fzf
      bat
      eza
      fd
      lazygit
      lazydocker
      gh
      delta
      direnv
      jq
    ];
  };
}
```

- [ ] Update `modules/hosts/thor/thor.nix`
- [ ] Add `zsh` to nixos imports
- [ ] Change `homeManager` → `home`
- [ ] Keep individual tool imports (no shell customization needed)

#### C. Update modules/hosts/odin.nix

**Current:**
```nix
{inputs, ...}: {
  flake.modules.homeManager.odin = {
    imports = with inputs.self.modules.homeManager; [utilities neovim];
  };
}
```

**New:**
```nix
{inputs, ...}: {
  flake.modules.darwin.odin = {
    imports = with inputs.self.modules.darwin; [
      zsh              # System-level zsh for macOS
      # Add desktop when darwin.desktop is implemented
    ];
  };

  flake.modules.home.odin = {
    imports = with inputs.self.modules.home; [
      utilities        # CLI tools
      zsh              # User zsh config
      starship         # Prompt customization
      neovim           # Editor
    ];
  };
}
```

- [ ] Update `modules/hosts/odin.nix`
- [ ] Add `darwin.odin` section with system-level config
- [ ] Add `zsh` to darwin imports
- [ ] Add `zsh`, `starship` to home imports
- [ ] Change `homeManager` → `home`

### Quality Checks
```bash
alejandra --check .
statix check .
deadnix --fail .
nix flake check --impure
```

### Commit
```
refactor(hosts): update all host configs for new module structure

- Update freya to use nixos.desktop aggregator and explicit home modules
- Update thor to use system zsh and individual CLI tools
- Update odin to use darwin.zsh and explicit home modules
- Remove redundant imports (home-manager, individual wayland tools)

Host configurations are now simpler and more explicit.
```

---

## Phase 10: Cleanup Old Aggregator

**Goal:** Remove old `modules/desktop/imports.nix` (replaced by `desktop.nix`).

### Tasks

- [ ] Verify `modules/desktop/desktop.nix` is doing all the aggregation
- [ ] Check if `modules/desktop/imports.nix` is still referenced anywhere: `grep -r "imports.nix" modules/`
- [ ] `git rm modules/desktop/imports.nix`

### Quality Checks
```bash
alejandra --check .
statix check .
deadnix --fail .
nix flake check --impure
```

### Commit
```
chore(desktop): remove old imports.nix aggregator

- Remove modules/desktop/imports.nix (replaced by desktop.nix)
- All aggregation now in desktop.nix with platform sections
```

---

## Phase 11: Final Quality Checks & Documentation

**Goal:** Ensure everything works and document the new structure.

### Tasks

#### A. Run comprehensive checks
- [ ] Format: `alejandra .`
- [ ] Lint: `statix check .`
- [ ] Dead code: `deadnix --fail .`
- [ ] Build: `nix flake check --impure`
- [ ] Count files: `find modules -name "*.nix" | wc -l` (should be ~139 or less)

#### B. Test builds (optional but recommended)
- [ ] `nixos-rebuild build --flake .#freya`
- [ ] `nixos-rebuild build --flake .#thor`
- [ ] If on Darwin: `darwin-rebuild build --flake .#odin`

#### C. Update documentation
- [ ] Update `docs/reference/architecture.md` to reflect new structure
- [ ] Document the new module organization pattern
- [ ] Update examples to show platform-specific desktop aggregators

#### D. Update CLAUDE.md if needed
- [ ] Review workflow - still accurate?
- [ ] Update module placement examples if needed

### Commit
```
docs: update architecture documentation for new module organization

- Document platform-specific desktop aggregators
- Update module placement examples
- Reflect homeManager → home rename
- Add examples of new shell configuration pattern
```

---

## Final Steps

### Merge Preparation
- [ ] Review all commits on branch
- [ ] Squash if desired (or keep atomic commits)
- [ ] Write comprehensive PR description
- [ ] Create PR: `refactor/module-organisation` → `main`

### PR Description Template
```markdown
# Module Organization Refactor

## Summary
Reorganizes module structure to support platform-specific desktop configurations while maintaining aspect-oriented organization.

## Key Changes
- Renamed `homeManager` → `home` throughout codebase for brevity
- Enabled home-manager by default on all systems (nixos + darwin)
- Separated shell configuration into system and user modules
- Created platform-specific desktop aggregators (nixos.desktop, darwin.desktop)
- Consolidated web apps with co-located keybinds
- Extracted XDG config into separate module
- Simplified host configurations

## Migration Guide
Host configs now use:
- `nixos.desktop` or `darwin.desktop` for full desktop setup
- `nixos.zsh` / `darwin.zsh` for system-level shell
- `home.zsh` for user zsh config
- `home.starship` for optional prompt customization

## Testing
- [x] All quality checks pass (alejandra, statix, deadnix)
- [x] Flake evaluation succeeds
- [ ] NixOS builds: freya, thor
- [ ] Darwin builds: odin (if applicable)
```

---

## Progress Tracking

### Phases Completed
- [ ] Phase 1: Setup & Preparation
- [ ] Phase 2: Core Rename (homeManager → home)
- [ ] Phase 3: System Defaults
- [ ] Phase 4: Shell Separation
- [ ] Phase 5: Desktop Aggregation
- [ ] Phase 6: Web Apps Consolidation
- [ ] Phase 7: XDG Separation
- [ ] Phase 8: Alias Migration
- [ ] Phase 9: Host Configuration Updates
- [ ] Phase 10: Cleanup Old Aggregator
- [ ] Phase 11: Final Quality Checks & Documentation

### Estimated Commits
Total: ~11 commits (one per phase, excluding setup)

---

## Notes & Decisions

### Key Architectural Decisions
1. **Aspect folders stay intact** - No reorganization into platform-specific directories
2. **Single aggregator file** - `modules/desktop/desktop.nix` handles all platform logic
3. **Home-manager always enabled** - Simplifies host configuration
4. **Shell as opt-in** - Hosts choose zsh explicitly, otherwise get bash
5. **Web apps co-located** - .desktop entries live with their keybinds

### Files Changed (Estimated)
- Created: ~5 new files
- Modified: ~90 files (rename homeManager → home)
- Deleted: ~10 files (old web app files, keybinds-webapps.nix)

### Potential Issues
- **Icon paths** in webapps.nix need to be adjusted (relative paths from new location)
- **Hyprland dependency** in webapps means it won't work on non-Hyprland Linux systems (acceptable trade-off)
- **Darwin desktop** not fully implemented yet (just sets up home.desktop for now)
