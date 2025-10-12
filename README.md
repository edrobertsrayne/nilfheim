# 🏔️ Nilfheim - NixOS/Darwin Configuration

A declarative, modular infrastructure-as-code configuration for personal homelab
and development workstations.

## Overview

Nilfheim is a NixOS flake-based configuration managing self-hosted services,
enterprise-grade infrastructure, and cross-platform development environments.
Built for reproducibility, security, and ease of management.

**What it provides:**

- **Self-hosted homelab services** - Media streaming, automation, monitoring,
  and utilities
- **Enterprise infrastructure** - ZFS storage, mesh networking, centralized
  logging, encrypted backups
- **Reproducible deployments** - Declarative configuration across Linux and
  macOS hosts
- **Developer-friendly workflow** - Automated validation, one-command deploys,
  modular design

**Target audience**: NixOS users building homelabs, learning declarative
infrastructure, or managing multi-host environments.

## Architecture

Nilfheim manages four hosts with specialized roles:

- **Thor** (homelab server) - Media services, monitoring stack, centralized
  storage, network infrastructure
- **Freya** (ThinkPad T480s laptop) - Workstation with GNOME/Hyprland, connects
  to Thor via NFS
- **Loki** (VPS) - Lightweight cloud deployment
- **Odin** (macOS) - Cross-platform development environment

**Design principles:**

- **Role-based composition** - Hosts select from predefined roles (common,
  server, workstation, vps)
- **Centralized constants** - Single source of truth for ports, paths, network
  settings (`lib/constants.nix`)
- **Service abstractions** - DRY configuration for similar services (e.g., *arr
  suite via `mkArrService`)
- **Modular organization** - Services by category, clear separation of
  platform-specific code

**Technologies**: NixOS, ZFS with impermanence, Tailscale mesh network, agenix
secrets management.

See [CLAUDE.md Architecture Overview](CLAUDE.md#architecture-overview) for
detailed system design.

## 📁 Project Structure

```
├── flake.nix              # Main flake configuration and dev shell
├── hosts/                 # Host-specific configurations
│   ├── freya/             # ThinkPad laptop
│   ├── thor/              # Homelab server
│   ├── loki/              # VPS server
│   └── odin/              # macOS system
├── modules/               # Modular system configurations
│   ├── common/            # Shared across platforms
│   ├── nixos/             # NixOS-specific modules
│   │   └── services/      # Service modules by category
│   ├── darwin/            # macOS-specific modules
│   └── home/              # Home-manager configurations
├── roles/                 # Predefined role combinations
├── lib/                   # Shared functions and constants
└── secrets/               # Encrypted secrets with agenix
```

## Capabilities

### 🏠 Home Server (Thor)

**Media & Downloads**

- Jellyfin streaming server with Jellyseerr request management
- *arr automation suite (Sonarr, Radarr, Lidarr, Bazarr, Prowlarr)
- Transmission BitTorrent client with network access, peer port open for optimal
  connectivity
- SABnzbd Usenet downloader with automatic download directory configuration
- Download management tools (Cleanuparr, Huntarr) for automated cleanup and
  organization
- Flaresolverr CAPTCHA solver, Recyclarr quality profile management

**Monitoring & Analytics**

- Grafana dashboards (9 comprehensive dashboards including Homelab Overview)
- Prometheus metrics collection with custom exporters
- Loki log aggregation with Promtail (systemd, Docker, applications)
- PostgreSQL with advanced DNS query analytics via Blocky
- Uptime monitoring, AlertManager notifications

**Utilities & Automation**

- Homepage dashboard for unified service access
- N8N workflow automation
- Code-server for web-based development
- Document management (Stirling PDF), recipe manager (Mealie)
- AI-powered bookmark organizer (Karakeep)

**Containers**

- Docker with systemd integration and auto-pull updates
- Container services: Home Assistant, Tdarr transcoder, Cleanuparr, Huntarr
- Portainer for container management web UI
- cAdvisor for container metrics and monitoring

### 🛡️ Infrastructure

**Storage**

- ZFS filesystem with automatic snapshots and data integrity
- NFS server for high-performance network shares over Tailscale
- Samba shares for local network access
- Restic encrypted backups with monitoring and alerting
- Impermanence for stateless root with selective persistence

**Networking**

- Tailscale mesh VPN for secure remote access with MagicDNS
- Blocky DNS with ad-blocking, logging, and analytics
- Nginx reverse proxy with automatic SSL and WebSocket support
- Cloudflare tunnels for external access
- Interface-specific firewall rules for service isolation

**Security**

- SSH hardening (key-only auth, no root login, rate limiting)
- Fail2ban intrusion prevention with progressive bans
- agenix encrypted secrets management with per-host age keys
- Sudo password enforcement, no NOPASSWD access

### 💻 Development Environment

**Workstation (Freya)**

- GNOME and Hyprland desktop environments with GDM
- Catppuccin Mocha theming across all applications
- Development tools (VSCode, Firefox, terminals)
- NFS client for accessing Thor's shared storage
- ZFS with impermanence for clean system state

**Cross-Platform (Odin)**

- Darwin (macOS) support with Homebrew integration
- Consistent development environment across platforms

**Tooling**

- Nix flakes for reproducible builds
- Automated CI/CD validation (format, lint, static analysis)
- One-command deployments via Just recipes
- Development shell with all required tools

## 🚀 Quick Start

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

## 🔒 Security

- **Authentication**: SSH key-only authentication, sudo password enforcement
- **Network**: Tailscale mesh VPN, interface-specific firewall rules (SMB/NFS
  over tailscale only)
- **Intrusion Prevention**: Fail2ban with progressive bans (24h → 7d for
  repeated offenses)
- **Secrets**: agenix encryption with per-host age keys
- **Storage**: NFS over Tailscale, Samba with authentication and access controls
- **Monitoring**: Comprehensive logging and alerting for security events

See [CLAUDE.md Security Architecture](CLAUDE.md#security-architecture) for
detailed configuration.

## 📚 Documentation

### For Developers

- **[CLAUDE.md](CLAUDE.md)** - Architecture overview, development guide,
  configuration patterns
- **[docs/command-reference.md](docs/command-reference.md)** - Complete command
  documentation
- **[docs/documentation-standards.md](docs/documentation-standards.md)** -
  Documentation guidelines and standards

### For Operations

- **[docs/backup-operations.md](docs/backup-operations.md)** - Backup
  management, recovery procedures, repository maintenance
- **[docs/monitoring.md](docs/monitoring.md)** - Loki log queries, Prometheus
  metrics, Grafana dashboards
- **[docs/troubleshooting.md](docs/troubleshooting.md)** - Common issues,
  solutions, debug commands

### Project Management

- **[TODO.md](TODO.md)** - Roadmap and pending improvements
- **[docs/database-services.md](docs/database-services.md)** - PostgreSQL setup
  and integration patterns
- **[docs/monitoring-dashboards.md](docs/monitoring-dashboards.md)** - Dashboard
  details and analytics

### External Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/) - Official NixOS
  documentation
- [NixOS Options Search](https://search.nixos.org/options) - Search available
  configuration options
- [Home Manager](https://nix-community.github.io/home-manager/) - User
  environment management
- [Nix Package Search](https://search.nixos.org/packages) - Find packages in
  nixpkgs

---

**Development**: See [CLAUDE.md](CLAUDE.md) for complete architecture details
and development workflow.

**Operations**: See [docs/](docs/) for backup, monitoring, and troubleshooting
guides.
