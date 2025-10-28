# Nilfheim

> A beautiful, aspect-oriented NixOS configuration following dendritic principles

Nilfheim is a complete NixOS configuration built around **dendritic architecture** — organizing modules by *what they do* rather than *where they run*. The result is a highly modular, composable, and maintainable system that embraces keyboard-first workflows and aesthetic design.

---

## Overview

This configuration represents a ground-up rewrite focusing on:

- **Aspect-Oriented Architecture**: Modules organized by purpose (desktop, development, media, system)
- **Automatic Module Loading**: Zero-maintenance imports via `import-tree`
- **Composable Design**: Mix and match aspects to build systems declaratively
- **Keyboard-First Workflow**: Everything accessible via keyboard (inspired by omarchy)
- **Unified Theming**: System-wide consistency through Stylix (Tokyo Night)
- **Self-Documenting**: Clear module boundaries with explicit dependencies

---

## Features

### Desktop Environment

- **Hyprland** compositor with comprehensive window management
- **Stylix** theming system (Tokyo Night colorscheme)
- **Walker** application launcher (Super+Space)
- **Waybar** status bar with system information
- **Custom launchers** for browser, terminal, and webapps
- **SwayOSD** for volume and brightness feedback

### Development Tools

- **Nixvim** with LazyVim-inspired plugins and keymaps
- **Tmux** with vim-tmux-navigator integration
- **CLI utilities**: bat, eza, fzf, delta, lazygit, lazydocker, zoxide
- **Dev shells** for project-specific environments

### Media Server Stack

- **Jellyfin** media server
- **Jellyseerr** request management
- **Arr Suite**: Sonarr, Radarr, Lidarr, Prowlarr
- **Transmission** BitTorrent client
- **Sabnzbd** Usenet client

### Infrastructure

- **Home Assistant** home automation
- **Blocky** DNS server with ad-blocking
- **Portainer** container management with Cloudflare tunnel
- **NFS/Samba** network file sharing
- **Tailscale** mesh VPN
- **Docker** container runtime

---

## Influences & Credits

**Architecture & Configuration Management:**

- [dendrix](https://github.com/vic/dendrix) - Dendritic architecture
  principles for aspect-oriented NixOS configs
- [vix](https://github.com/vic/vix) - Reference implementation of dendritic
  patterns
- [GaetanLepage/nix-config](https://github.com/GaetanLepage/nix-config) -
  Modern NixOS configuration patterns
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles) - NixOS and
  Hyprland configuration inspiration

**Desktop & Design:**

- [omarchy](https://github.com/basecamp/omarchy) - Overall design
  philosophy, keyboard-first workflow, custom launcher scripts, and aesthetic
  approach
- [stylix](https://github.com/danth/stylix) - System-wide theming engine

---

## Quick Start

### Prerequisites

- NixOS with flakes enabled
- Git configured with SSH access to this repository

### Clone & Build

```bash
# Clone the repository
git clone git@github.com:edrobertsrayne/nilfheim.git
cd nilfheim

# Build a specific host configuration
sudo nixos-rebuild switch --flake .#freya  # Desktop
sudo nixos-rebuild switch --flake .#thor   # Server
```

### Deploy from Remote

```bash
# Build and deploy to a remote host
nixos-rebuild switch --flake github:edrobertsrayne/nilfheim#thor \
  --target-host thor --use-remote-sudo
```

---

## Project Structure

```text
nilfheim/
├── flake.nix              # Entry point (minimal, just inputs)
├── modules/
│   ├── desktop/           # Desktop environment aspects
│   ├── hyprland/          # Hyprland compositor configuration
│   ├── nixvim/            # Neovim configuration
│   ├── utilities/         # CLI tools (one file per tool)
│   ├── services/          # System services
│   ├── media/             # Media server aspects
│   ├── system/            # Core system configuration
│   ├── development/       # Development tools and shells
│   ├── packages/          # Custom package derivations
│   ├── nilfheim/          # Custom project options
│   ├── hosts/             # Host-specific configurations
│   ├── flake/             # Flake-parts configuration
│   └── lib/               # Helper functions and themes
├── secrets/               # Encrypted secrets (agenix)
└── docs/                  # Documentation
    ├── reference/         # Technical reference docs
    ├── TMUX_CHEATSHEET.md
    └── HYPRLAND_SHORTCUTS.md
```

For detailed architecture information, see
[docs/reference/architecture.md](docs/reference/architecture.md).

---

## Current Hosts

| Host    | Type    | Status | Description |
|---------|---------|--------|-------------|
| **freya** | Desktop | ✅ Active | Main development workstation with Hyprland |
| **thor**  | Server  | ✅ Active | Media server with Jellyfin and *arr suite |
| **odin**  | Desktop  | ⏸️ Pending | Not yet migrated to dendritic architecture |
| **loki**  | Server  | 🗑️ Retired | May be decommissioned |

---

## Documentation

### Quick References

- [Hyprland Shortcuts](docs/HYPRLAND_SHORTCUTS.md) - Keyboard shortcuts for
  window management
- [Tmux Cheatsheet](docs/TMUX_CHEATSHEET.md) - Terminal multiplexer shortcuts

### Reference Documentation

- [Architecture](docs/reference/architecture.md) - Project structure and
  dendritic principles
- [Module Templates](docs/reference/module-templates.md) - Code templates for
  new modules
- [Anti-Patterns](docs/reference/anti-patterns.md) - Common mistakes to avoid
- [Commit Guide](docs/reference/commit-guide.md) - Conventional commits with
  examples
- [Troubleshooting](docs/reference/troubleshooting.md) - Error recovery and
  debugging

### AI Agent Guidelines

- [CLAUDE.md](CLAUDE.md) - Workflow and rules for AI-assisted development

---

## Development

### Quality Checks

All changes must pass these checks before committing:

```bash
alejandra --check .              # Format check
statix check .                   # Linting
deadnix --fail .                 # Dead code detection
nix flake check --impure         # Build verification
```

Auto-fix formatting:

```bash
alejandra .
```

### Workflow

This project follows a strict four-phase workflow for all changes:

1. **EXPLORE** - Understand the codebase (read-only)
2. **PLAN** - Design the solution (no code changes)
3. **CODE** - Implement the approved plan
4. **COMMIT** - Verify quality and create commits

See [CLAUDE.md](CLAUDE.md) for detailed workflow guidelines.

### Adding New Modules

**Simple aspect** (single concern):

```nix
# modules/ssh.nix
{
  flake.modules.nixos.ssh = {
    services.openssh.enable = true;
  };
}
```

**Complex feature** (multiple files):

```text
modules/nixvim/
├── nixvim.nix      # Main configuration
├── keymaps.nix     # Keyboard shortcuts
├── lsp.nix         # Language servers
└── plugins.nix     # Plugin configuration
```

**Important**: Always `git add` new `.nix` files immediately — `import-tree`
only loads git-tracked files!

See [docs/reference/module-templates.md](docs/reference/module-templates.md)
for more examples.

---

## Commit Guidelines

Use [Conventional Commits](https://www.conventionalcommits.org/) with aspect
names as scope:

```text
feat(nixvim): add LSP support for Rust
fix(hyprland): correct keybind for workspace switching
refactor(desktop): reorganize aggregator imports
chore(flake): update nixpkgs input
```

See [docs/reference/commit-guide.md](docs/reference/commit-guide.md) for
detailed examples.

---

## License

MIT License - See LICENSE file for details

---

## Acknowledgments

Special thanks to the NixOS community and the creators of the projects that
influenced this configuration. Standing on the shoulders of giants makes
building beautiful systems possible.

🌳 **Built with dendritic principles for a cleaner, more maintainable NixOS
configuration.**
