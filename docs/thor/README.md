# Thor - Homelab Server Documentation

**Thor** is the central homelab server providing media streaming, download automation, monitoring, and network services for the Nilfheim infrastructure.

## Quick Reference

| Property | Value |
|----------|-------|
| **Hostname** | thor |
| **IP Address** | 192.168.68.122 (LAN) |
| **Domain** | greensroad.uk |
| **OS** | NixOS (declarative configuration) |
| **Storage** | ZFS (zroot + tank pools) |
| **Services** | 40+ services across media, monitoring, utilities |
| **Dashboard** | https://homepage.greensroad.uk |

## Quick Start

### Checking System Status

```bash
# Overall system health
systemctl status

# Check ZFS pool status
zpool status
zfs list

# Monitor system resources
htop
# or
https://glances.greensroad.uk

# View service dashboard
https://homepage.greensroad.uk
```

### Common Operations

```bash
# Restart a service
sudo systemctl restart <service>

# View service logs
journalctl -u <service> -f

# Check service status
systemctl status <service>

# Test backup system
sudo systemctl status restic-backups-system.service
restic -r /mnt/backup/thor/restic snapshots
```

## System Overview

Thor serves as:
- **Media Hub**: Jellyfin streaming server, audiobook/ebook library
- **Automation Engine**: *arr stack for content acquisition and management
- **Monitoring Center**: Prometheus + Grafana + Loki for infrastructure observability
- **Network Services**: DNS (Blocky), file sharing (NFS/Samba), VPN (Tailscale)
- **Backup Server**: Restic backups + ZFS snapshots for data protection

### Key Features
- ✅ Declarative NixOS configuration (reproducible and version-controlled)
- ✅ ZFS with automatic snapshots (15min, hourly, daily, weekly, monthly)
- ✅ Comprehensive monitoring (Prometheus exporters for all critical services)
- ✅ Secure remote access (Cloudflared tunnel + Tailscale VPN)
- ✅ Automated backups (Restic with configurable retention)
- ✅ Impermanence setup (clean state on reboot, selected data persists)

## Documentation Sections

### System Configuration
- **[System Architecture](system-architecture.md)** - Hardware specs, ZFS layout, boot configuration
- **[Network Configuration](network-configuration.md)** - IP addressing, firewall, DNS, proxy setup
- **[Storage & Shares](storage-and-shares.md)** - ZFS pools, NFS exports, Samba shares

### Services
- **[Services Inventory](services/README.md)** - Complete list of all services with ports and URLs
- Service-specific documentation in `services/` directory

### Operations
- **[Monitoring & Alerting](monitoring-and-alerting.md)** - How to monitor system health and respond to alerts
- **[Backup & Recovery](backup-and-recovery.md)** - Backup schedules, restore procedures
- **[Troubleshooting Guide](troubleshooting-guide.md)** - Common issues and solutions
- **[Security](security.md)** - Security configuration and hardening measures

## Service Categories

### Media Services (🎬)
| Service | Purpose | URL |
|---------|---------|-----|
| Jellyfin | Media streaming server | https://jellyfin.greensroad.uk |
| Jellyseerr | Media request management | https://jellyseerr.greensroad.uk |
| Audiobookshelf | Audiobook/podcast server | https://audiobookshelf.greensroad.uk |
| Kavita | Digital library (comics/ebooks) | https://kavita.greensroad.uk |

### Download Management (📥)
| Service | Purpose | Port |
|---------|---------|------|
| Sonarr | TV series management | 8989 |
| Radarr | Movie management | 7878 |
| Lidarr | Music management | 8686 |
| Bazarr | Subtitle management | 6767 |
| Prowlarr | Indexer manager | 9696 |
| Transmission | BitTorrent client | 9091 |
| Recyclarr | *arr config sync | - |

### Monitoring Stack (📊)
| Service | Purpose | URL |
|---------|---------|-----|
| Prometheus | Metrics collection | https://prometheus.greensroad.uk |
| Grafana | Visualization dashboards | https://grafana.greensroad.uk |
| Loki | Log aggregation | https://loki.greensroad.uk |
| Alertmanager | Alert routing | https://alertmanager.greensroad.uk |
| Uptime Kuma | Uptime monitoring | https://uptime-kuma.greensroad.uk |
| Glances | System monitoring | https://glances.greensroad.uk |

### Utilities (🔧)
| Service | Purpose | URL |
|---------|---------|-----|
| Homepage | Service dashboard | https://homepage.greensroad.uk |
| N8N | Workflow automation | https://n8n.greensroad.uk |
| Code Server | VS Code in browser | https://code-server.greensroad.uk |
| Stirling PDF | PDF tools | https://stirling-pdf.greensroad.uk |
| Karakeep | Karaoke management | https://karakeep.greensroad.uk |
| Mealie | Recipe manager | https://mealie.greensroad.uk |
| pgAdmin | PostgreSQL admin | https://pgadmin.greensroad.uk |

### Network Services (🌐)
| Service | Purpose | Notes |
|---------|---------|-------|
| Blocky | DNS proxy/ad-blocker | Port 4000, PostgreSQL logging |
| NFS Server | Network file shares | Exports to freya via Tailscale |
| Samba | SMB file shares | Guest access enabled |
| Tailscale | Mesh VPN | Exit node + subnet routing |
| Cloudflared | Tunnel proxy | UUID: 23c4423f-ec30-423b-ba18-ba18904ddb85 |
| Nginx | Reverse proxy | All HTTPS endpoints |

### Containers (🐳)
| Service | Container Runtime | Purpose |
|---------|-------------------|---------|
| Home Assistant | Podman | Home automation platform |
| Tdarr | Podman | Media transcoding |

## Storage Layout

### ZFS Pools

**zroot** (NVMe - /dev/nvme0n1):
- `local/root` - Root filesystem (/) - ephemeral, blank on boot
- `local/nix` - Nix store (/nix) - persistent
- `local/persist` - System persistence (/persist) - persistent
- `local/srv` - Service data (/srv) - persistent, auto-snapshot enabled

**tank** (HDD - /dev/sda):
- `backup` - Backup storage (/mnt/backup) - Restic repository
- `share` - General file share (/mnt/share) - NFS/Samba
- `media` - Media library (/mnt/media) - movies, TV, music, audiobooks, comics
- `downloads` - Download directory (/mnt/downloads) - torrent/usenet staging

### Network Shares

| Share | Path | NFS | Samba | Purpose |
|-------|------|-----|-------|---------|
| downloads | /mnt/downloads | RW | RW | Download staging area |
| media | /mnt/media | RO | RO | Media library (read-only) |
| backup | /mnt/backup | RW | RW | Backup storage |
| share | /mnt/share | RW | RW | General file sharing |

## Network Configuration

- **LAN IP**: 192.168.68.122 (static via DHCP)
- **Tailscale**: Part of mesh VPN, acts as exit node
- **Subnet Routing**: Advertises 192.168.68.0/24 to Tailscale network
- **External Access**: Cloudflared tunnel to greensroad.uk
- **DNS**: Blocky on port 4000 (local DNS resolver with ad-blocking)
- **Firewall**: Restrictive by default, service-specific ports opened

## Monitoring & Health Checks

### Quick Health Check
```bash
# All critical services
systemctl --failed

# ZFS pools
zpool status

# Disk space
df -h
zfs list -o name,used,avail,mountpoint

# Recent backups
restic -r /mnt/backup/thor/restic snapshots | tail -5

# Service logs (last 50 lines)
journalctl -u <service> -n 50
```

### Dashboards
- **Homepage**: https://homepage.greensroad.uk - Service overview with status
- **Grafana**: https://grafana.greensroad.uk - Metrics and performance
- **Uptime Kuma**: https://uptime-kuma.greensroad.uk - Historical uptime
- **Glances**: https://glances.greensroad.uk - Real-time system stats

## Configuration Management

Thor's configuration is managed declaratively via NixOS:

**Source Files**:
- Host config: `hosts/thor/default.nix`
- Role: `roles/homelab.nix`
- Service modules: `modules/nixos/services/`
- Constants: `lib/constants.nix`

**Deployment**:
```bash
# Local rebuild (on thor)
sudo nixos-rebuild switch --flake .#thor

# Remote rebuild (from another machine)
nixos-rebuild switch --flake .#thor --target-host thor --build-host thor --sudo

# Using justfile
just thor
```

## Backup & Recovery

### Backup Schedule
- **Restic**: Daily automated backups to `/mnt/backup/thor/restic`
- **ZFS Snapshots**: 
  - Frequent: every 15 minutes (keep 4)
  - Hourly: every hour (keep 24)
  - Daily: every day (keep 14)
  - Weekly: every week (keep 8)
  - Monthly: every month (keep 6)

### Recovery
See [Backup & Recovery](backup-and-recovery.md) for detailed procedures.

## Security

- **SSH**: Key-only authentication, no root login, no passwords
- **Firewall**: Restrictive rules, service-specific port allowances
- **Fail2ban**: Active intrusion prevention (SSH, nginx)
- **Secrets**: Age-encrypted via agenix
- **Network Isolation**: Services behind Tailscale VPN or Cloudflared tunnel
- **Samba**: Guest access enabled (⚠️ consider security implications)

For more details, see [Security Documentation](security.md).

## Getting Help

1. **Check service status**: `systemctl status <service>`
2. **View logs**: `journalctl -u <service> -f`
3. **Consult dashboards**: Grafana, Homepage, Uptime Kuma
4. **Troubleshooting guide**: [troubleshooting-guide.md](troubleshooting-guide.md)
5. **Check monitoring alerts**: Alertmanager for active issues

## Related Documentation

- [📋 Main Documentation Index](../README.md)
- [🛠️ Development Guide](../../CLAUDE.md)
- [🔍 Service Inventory](services/README.md)
- [🔧 Troubleshooting](troubleshooting-guide.md)

---

**Configuration Source**: [`hosts/thor/default.nix`](../../hosts/thor/default.nix) | [`roles/homelab.nix`](../../roles/homelab.nix)  
**Last Updated**: Auto-generated from NixOS configuration
