# 🏔️ Nilfheim - NixOS/Darwin Configuration

Ed's modular NixOS and Darwin flake configuration for system management across multiple hosts.

## 🏗️ Architecture

- **🖥️ Hosts**: `freya` (ThinkPad T480s), `thor` (homelab server), `loki` (additional server), `odin` (macOS), `iso` (installer)
- **🎭 Roles**: common, workstation, laptop, server, homelab, gaming, vps
- **📦 Modules**: organized by platform (nixos/darwin/home) and functionality
- **🔐 Secrets**: managed with agenix encryption

## 📁 Project Structure

```
├── flake.nix              # Main flake configuration and dev shell
├── hosts/                 # Host-specific configurations
│   ├── freya/             # ThinkPad laptop
│   ├── thor/              # Homelab server
│   └── odin/              # macOS system
├── modules/               # Modular system configurations
│   ├── common/            # Shared across platforms
│   ├── nixos/             # NixOS-specific modules
│   │   ├── services/      # Service modules organized by category
│   │   │   ├── data/      # Database services (PostgreSQL, pgAdmin)
│   │   │   ├── monitoring/# Monitoring stack (Grafana, Prometheus, Loki)
│   │   │   └── ...        # Other service categories
│   ├── darwin/            # macOS-specific modules
│   └── home/              # Home-manager configurations
├── roles/                 # Predefined role combinations
└── secrets/               # Encrypted secrets with agenix
```

## 🚀 Modern Infrastructure Features

### 🔍 Advanced DNS Analytics
- **Real-time Monitoring**: Live DNS query analysis with response type categorization
- **Performance Insights**: Response time tracking with percentile analysis
- **Security Analytics**: Block effectiveness monitoring with threat pattern detection
- **Client Intelligence**: Device and user behavior analysis with anomaly detection
- **Cache Optimization**: Hit rate analysis for performance tuning
- **Comprehensive Dashboards**: 21-panel Grafana dashboard with enterprise-grade DNS insights

### 🐳 Container Management
- **Podman**: Rootless containerization for Home Assistant and Tdarr
- **Systemd Integration**: Native service management for containers

### 💾 Storage & Persistence
- **ZFS**: Advanced filesystem with snapshots and data integrity
- **Impermanence**: Stateless root with selective persistence
- **Disko**: Declarative disk partitioning
- **Backup**: Restic encrypted backups with Loki monitoring
  - **Thor**: `/persist` and `/srv` → `/mnt/backup/thor/restic`
  - **Freya**: `/persist` and `/home` → `/mnt/backup/freya/restic`
  - **Centralized Storage**: NFS-shared backup repository on Thor
  - **Monitoring**: SystemD journal logs aggregated via Loki with Grafana dashboard

### 📊 Monitoring & Analytics Stack
- **Metrics**: Prometheus + Grafana with comprehensive dashboards
- **Logs**: Loki + Promtail for centralized log aggregation
- **DNS Analytics**: PostgreSQL + Grafana for advanced DNS query analysis
- **Health**: Custom exporters for *arr services and system monitoring  
- **Alerts**: AlertManager with notification routing
- **Database**: PostgreSQL with pgAdmin web interface for data exploration

## ✨ Key Features

### ⚡ Thor - Homelab Server
- **🎬 Media**: Jellyfin, Audiobookshelf, Jellyseerr, Kavita (ebooks)
- **📥 Downloads**: *arr suite (Sonarr, Radarr, Lidarr, Bazarr, Prowlarr), Transmission, Recyclarr, Flaresolverr
- **📈 Monitoring**: Grafana, Prometheus, AlertManager, Uptime Kuma, Glances, Loki, Promtail
- **📊 Analytics**: PostgreSQL database with pgAdmin for DNS query logging and analysis
- **🌐 Network**: Nginx reverse proxy, Blocky DNS with logging, Tailscale, SSH, Cloudflared tunnels
- **💾 Storage**: NFS server for shared storage over tailscale network, Samba shares for local access
- **🛠️ Utilities**: Homepage dashboard, Code-server, Karakeep (AI bookmarks), Stirling PDF, N8N automation
- **🐳 Virtualization**: Podman containers (Home Assistant, Tdarr)

### 💻 Freya - Workstation/Laptop
- **🖥️ Desktop**: GNOME and Hyprland with shared GDM display manager
- **🎨 Theming**: Catppuccin Mocha color scheme across all applications
- **👨‍💻 Development**: VSCode, Firefox, Foot terminal
- **🎨 Creative**: Arduino IDE, Spotify, Obsidian
- **🖱️ Virtualization**: virt-manager support
- **💾 Storage**: NFS client for accessing Thor's shared storage

### 🍎 Odin - macOS
- **🍺 Homebrew**: Managed application installation
- **⚙️ Development**: Cross-platform development environment

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

### 🔧 Manual Commands (if needed)
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

### 🛡️ Core Security Features
- **🔑 Authentication**: SSH key-only authentication with hardened config, sudo password enforcement
- **🚨 Intrusion Prevention**: Fail2ban with progressive bans for SSH/web attacks
- **🔐 Secrets**: agenix encrypted secrets management with age keys
- **🌐 Network**: Tailscale mesh VPN for secure remote access
- **🛡️ Isolation**: Firewall configuration per service with minimal exposure
- **💾 Storage**: NFS over tailscale network, Samba restricted to tailscale with access controls
- **🔀 Proxying**: Nginx reverse proxy with WebSocket support and security headers
- **🌉 Tunneling**: Cloudflared secure tunnels for external access

### 🔐 Security Hardening
- **SSH**: MaxAuthTries=3, ClientAliveInterval=300, no root/password login
- **Sudo**: Password required for all operations (no NOPASSWD)
- **Fail2ban**: 24h bans escalating to 7 days, monitors SSH/nginx/auth failures
- **Network Segmentation**: Services isolated to appropriate network ranges
- **Service Isolation**: Manual firewall control, interface-specific rules

## 🛠️ Development Workflow

See **CLAUDE.md** for complete development commands and patterns.

### ⚡ Quick Commands (via Just)
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

### 🔧 Manual Commands
- `nix fmt .` - Format all Nix files (required before commits)
- `statix check` - Lint for Nix code quality
- `deadnix -l` - Detect unused code
- `nix flake check` - Validate flake configuration

Commit format: `type(scope): description` (conventional commits)

## 💾 Backup Management

### 🔄 Automatic Backups
- **Schedule**: Daily backups with randomized delay
- **Retention**: 14 daily, 8 weekly, 6 monthly, 2 yearly snapshots
- **Encryption**: Repository-level encryption with auto-generated passwords
- **Monitoring**: Backup logs available in Grafana via Loki integration

### 📊 Backup Monitoring
```bash
# View backup dashboard
https://grafana.${domain}/d/restic-backup/restic-backup-monitoring

# Check backup service status
systemctl status restic-backups-system.service
journalctl -u restic-backups-system.service -f
```

### 🔍 Backup Validation & Management

**List Snapshots:**
```bash
# On thor
export RESTIC_REPOSITORY=/mnt/backup/thor/restic
export RESTIC_PASSWORD_FILE=/etc/restic/password
restic snapshots

# On freya
export RESTIC_REPOSITORY=/mnt/backup/freya/restic
export RESTIC_PASSWORD_FILE=/etc/restic/password
restic snapshots
```

**Validate Repository Integrity:**
```bash
# Quick check
restic check

# Thorough check (reads 10% of data)
restic check --read-data-subset=10%

# Full data verification (slow)
restic check --read-data
```

**Repository Information:**
```bash
# Show repository stats
restic stats

# Show storage usage by snapshot
restic stats --mode raw-data

# Show duplicate data savings
restic stats --mode restore-size
```

**Manual Backup Operations:**
```bash
# Trigger immediate backup
systemctl start restic-backups-system.service

# Manual restore (example)
restic restore latest --target /tmp/restore --include /persist/important-file

# Browse snapshot contents
restic ls latest

# Find files across snapshots
restic find "*.nix" --snapshot latest
```

**Repository Maintenance:**
```bash
# Clean up and optimize repository
restic forget --keep-daily 14 --keep-weekly 8 --keep-monthly 6 --keep-yearly 2 --prune

# Rebuild index (if corrupted)
restic rebuild-index

# Check and repair repository
restic check --read-data-subset=5%
```

### 🚨 Backup Recovery

**Full System Restore:**
1. Boot from NixOS installer
2. Set up disk partitioning with disko
3. Mount restore location: `mkdir /mnt/restore`
4. Restore critical data: `restic restore latest --target /mnt/restore`
5. Copy restored data to appropriate locations
6. Rebuild system: `nixos-rebuild switch --flake`

**Selective File Recovery:**
```bash
# List files in specific path
restic ls latest --long /persist/home

# Restore specific directory
restic restore latest --target /tmp/restore --include /persist/home/user/documents

# Restore with specific snapshot ID
restic restore abc123def --target /tmp/restore
```

## 📚 Documentation

- **📋 CLAUDE.md** - Development commands and workflow  
- **📝 TODO.md** - Planned improvements and pending tasks
- **🗂️ docs/** - Comprehensive documentation directory
  - **[Database Services](docs/database-services.md)** - PostgreSQL, pgAdmin, and integration patterns
  - **[Monitoring Dashboards](docs/monitoring-dashboards.md)** - Grafana dashboards and analytics
  - **[Documentation Index](docs/README.md)** - Complete documentation navigation