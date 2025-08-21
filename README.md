# Nilfheim - NixOS/Darwin Configuration

Ed's modular NixOS and Darwin flake configuration for system management across multiple hosts.

## Architecture

- **Hosts**: `freya` (ThinkPad T480s), `thor` (homelab server), `loki` (additional server), `odin` (macOS), `iso` (installer)
- **Roles**: common, desktop, laptop, homelab, gaming
- **Modules**: organized by platform (nixos/darwin/home) and functionality
- **Secrets**: managed with agenix encryption

## Project Structure

```
├── flake.nix              # Main flake configuration and dev shell
├── hosts/                 # Host-specific configurations
│   ├── freya/             # ThinkPad laptop
│   ├── thor/              # Homelab server
│   └── odin/              # macOS system
├── modules/               # Modular system configurations
│   ├── common/            # Shared across platforms
│   ├── nixos/             # NixOS-specific modules
│   ├── darwin/            # macOS-specific modules
│   └── home/              # Home-manager configurations
├── roles/                 # Predefined role combinations
└── secrets/               # Encrypted secrets with agenix
```

## Modern Infrastructure Features

### Container Management
- **Podman**: Rootless containerization for Home Assistant and Tdarr
- **Systemd Integration**: Native service management for containers

### Storage & Persistence
- **ZFS**: Advanced filesystem with snapshots and data integrity
- **Impermanence**: Stateless root with selective persistence
- **Disko**: Declarative disk partitioning

### Monitoring Stack
- **Metrics**: Prometheus + Grafana with custom dashboards
- **Logs**: Loki + Promtail for centralized log aggregation
- **Health**: Custom exporters for *arr services and system monitoring
- **Alerts**: AlertManager with notification routing

## Key Features

### Thor - Homelab Server
- **Media**: Jellyfin, Audiobookshelf, Jellyseerr, Kavita (ebooks)
- **Downloads**: *arr suite (Sonarr, Radarr, Lidarr, Bazarr, Prowlarr), Transmission, Recyclarr, Flaresolverr
- **Monitoring**: Grafana, Prometheus, AlertManager, Uptime Kuma, Glances, Loki, Promtail
- **Network**: Nginx reverse proxy, Blocky DNS, Tailscale, SSH, Cloudflared tunnels
- **Utilities**: Homepage dashboard, Code-server, Karakeep (AI bookmarks), Samba shares, Stirling PDF, N8N automation
- **Virtualization**: Podman containers (Home Assistant, Tdarr)

### Freya - Desktop/Laptop
- **Desktop**: GNOME with custom theming and fonts
- **Development**: VSCode, Firefox, Foot terminal
- **Creative**: Arduino IDE, Spotify, Obsidian
- **Virtualization**: virt-manager support

### Odin - macOS
- **Homebrew**: Managed application installation
- **Development**: Cross-platform development environment

## Quick Start

```bash
# Clone repository
git clone <repository-url> nilfheim
cd nilfheim

# Enter development shell (includes tools: claude-code, gh, git, alejandra, just)
nix develop

# See all available commands
just --list

# Format code and check flake
just check

# Deploy to hosts
just freya    # Local NixOS rebuild
just odin     # Local macOS rebuild  
just thor     # Remote deployment to thor
just loki     # Remote deployment to loki
```

### Manual Commands (if needed)
```bash
# Format code before any changes
nix fmt .

# Build and switch (replace <hostname> with freya, thor, loki, or odin)
sudo nixos-rebuild switch --flake .#<hostname>    # NixOS local
darwin-rebuild switch --flake .#<hostname>        # macOS

# Remote deployment (avoids cross-compilation)
nixos-rebuild switch --flake .#<hostname> --target-host <hostname> --build-host <hostname> --sudo
```

## Security

- **Authentication**: SSH key-only authentication with hardened config
- **Secrets**: agenix encrypted secrets management with age keys
- **Network**: Tailscale mesh VPN for secure remote access
- **Isolation**: Firewall configuration per service with minimal exposure
- **Storage**: Samba with authentication, encryption, and access controls
- **Proxying**: Nginx reverse proxy with WebSocket support
- **Tunneling**: Cloudflared secure tunnels for external access

## Development Workflow

See **CLAUDE.md** for complete development commands and patterns.

### Quick Commands (via Just)
```bash
# Development cycle
just check           # Format and validate flake
just ci-quality-dry  # Quick CI validation
just ci-validate     # Full local CI test

# Local CI testing
just ci-list         # See available workflows
just ci-quality      # Run quality checks (statix, deadnix, format)
just ci-pr           # Simulate pull request CI
```

### Manual Commands
- `nix fmt .` - Format all Nix files (required before commits)
- `statix check` - Lint for Nix code quality
- `deadnix -l` - Detect unused code
- `nix flake check` - Validate flake configuration

Commit format: `type(scope): description` (conventional commits)

## Documentation

- **CLAUDE.md** - Development commands and workflow
- **TODO.md** - Planned improvements and pending tasks