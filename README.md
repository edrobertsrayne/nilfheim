# Nilfheim - NixOS/Darwin Configuration

Ed's modular NixOS and Darwin flake configuration for system management across multiple hosts.

## Architecture

- **Hosts**: `freya` (ThinkPad T480s), `thor` (homelab server), `odin` (macOS), `iso` (installer)
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

## Key Features

### Thor - Homelab Server
- **Media**: Jellyfin, Plex, Audiobookshelf, Jellyseerr, Kavita
- **Downloads**: Autobrr, *arr suite (Sonarr, Radarr, etc.), Deluge, SABnzbd
- **Monitoring**: Grafana, Prometheus, Uptime Kuma, Glances
- **Network**: Nginx reverse proxy, Blocky DNS, Tailscale, SSH
- **Utilities**: Homepage dashboard, Samba shares, Stirling PDF

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

# Enter development shell
nix develop

# Build and switch (replace <hostname> with freya, thor, or odin)
sudo nixos-rebuild switch --flake .#<hostname>    # NixOS
darwin-rebuild switch --flake .#<hostname>        # macOS
```

## Security

- SSH key-only authentication
- agenix encrypted secrets management
- Tailscale VPN for secure remote access
- Firewall configuration per service
- Samba with authentication and encryption

## Documentation

- **CLAUDE.md** - Development commands and workflow
- **TODO.md** - Planned improvements and pending tasks