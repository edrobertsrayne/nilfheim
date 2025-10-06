# Documentation Generation Prompt

This prompt was used to generate the comprehensive thor server documentation. It can be reused or adapted for documenting other servers (freya, loki, odin) in the future.

---

You are documenting a NixOS home server configured using a modular flake-based architecture. Your goal is to create comprehensive, structured documentation that will help both humans and automated monitoring agents understand the system.

## Scope

**Focus on the `thor` machine only.** This is the homelab server. Future iterations will add documentation for other servers (freya, loki, odin), but for now, analyze and document only the `thor` machine's configuration.

## Configuration Architecture Context

Thor's configuration is spread across multiple files:
- **Host-specific**: `/hosts/thor/default.nix` - Thor-specific settings (ZFS, NFS, Samba shares)
- **Role definition**: `/roles/homelab.nix` - Services enabled for the homelab role
- **Service modules**: `/modules/nixos/services/` - Individual service implementations
- **Constants**: `/lib/constants.nix` - Centralized ports, paths, and configuration
- **Secrets**: `/secrets/` - Agenix-encrypted secrets management

## Your Task

Analyze the NixOS configuration files for `thor` and generate documentation covering:

### 1. System Overview
- Hardware specifications from `hosts/thor/hardware-configuration.nix`
- ZFS configuration (tank pool, datasets, auto-snapshots)
- Disko partitioning scheme
- NixOS version and impermanence setup
- Overall architecture: Media server + Monitoring + Automation

### 2. Storage Architecture
**Critical for Thor:**
- ZFS tank pool configuration and datasets
- ZFS auto-snapshot schedule (from `lib/constants.nix` snapshotRetention)
- Shared storage paths (`/mnt/media`, `/mnt/downloads`, `/mnt/backup`, `/mnt/share`)
- NFS exports configuration and clients (freya)
- Samba share configuration (network access, permissions)
- Restic backup configuration and schedule

### 3. Network Configuration
- Static IP: 192.168.68.122 (from `homelab.ip`)
- Tailscale configuration (exit node, subnet routing)
- Cloudflared tunnel (UUID: 23c4423f-ec30-423b-ba18-ba18904ddb85)
- Domain: greensroad.uk
- Nginx reverse proxy setup
- Firewall rules (refer to service modules for port configurations)
- Blocky DNS configuration
- Avahi/mDNS for local network discovery

### 4. Services Inventory

**Reference `roles/homelab.nix` for the complete list.** For each enabled service, document:
- Service name and purpose
- Port (from `lib/constants.nix` ports definition)
- Data directory (typically `/srv/<service-name>`)
- Whether it has Prometheus exporter
- URL scheme: `https://<service>.greensroad.uk` (proxied via nginx + cloudflared)
- Dependencies (e.g., *arr services depend on prowlarr, transmission)
- Configuration in `/modules/nixos/services/<category>/<service>.nix`

**Service Categories:**
1. **Media Services**: Jellyfin, Jellyseerr, Audiobookshelf, Kavita
2. ***arr Stack**: Sonarr, Radarr, Lidarr, Bazarr, Prowlarr, Recyclarr
3. **Download Clients**: Transmission (enabled), Deluge (disabled), Sabnzbd (disabled)
4. **Monitoring Stack**: Prometheus, Grafana, Alertmanager, Loki, Promtail, Uptime Kuma, Glances
5. **Prometheus Exporters**: smartctl-exporter, zfs-exporter, node-exporter, exportarr (for each *arr service)
6. **Utilities**: Homepage Dashboard, N8N, Code-Server, Stirling-PDF, Karakeep, Mealie
7. **Database**: PostgreSQL, pgAdmin
8. **Network Services**: Blocky DNS, NFS Server, Samba, Tailscale, Cloudflared, Nginx
9. **Virtualization**: Podman, Home Assistant (container), Tdarr (container)
10. **Backup**: Restic (to `/mnt/backup/thor/restic`)

### 5. Container Services (Podman-based)
For containers (Home Assistant, Tdarr):
- Refer to `/modules/nixos/virtualisation/<service>.nix`
- Container configuration via NixOS modules (not raw Docker compose)
- Volume mounts and persistence
- Network integration with host services

### 6. Monitoring & Observability
**Thor has a comprehensive monitoring stack:**
- Prometheus scraping configuration (check which exporters/services)
- Grafana dashboards and data sources
- Loki log aggregation (sources from promtail)
- Alertmanager notification rules
- Service health monitoring
- Uptime Kuma status page

### 7. Backup & Data Protection
- Restic backup schedule and repository location
- ZFS snapshot retention policy (frequent=4, hourly=24, daily=14, weekly=8, monthly=6)
- What's included in backups vs snapshots
- Restore procedures

### 8. Security Configuration
- Fail2ban setup (from `/modules/nixos/services/security/fail2ban.nix`)
- SSH hardening (key-only, no root, from `/modules/nixos/services/network/ssh.nix`)
- Sudo password requirement (wheelNeedsPassword=true)
- Tailscale network isolation
- Cloudflared tunnel security
- Samba guest access (note security implications)
- Secret management via agenix

### 9. Operational Baselines
- Expected resource usage (Jellyfin transcoding will spike CPU/GPU)
- Systemd timers for recyclarr, backups
- Auto-update settings (check if enabled)
- Impermanence implications (what persists across reboots)

### 10. Troubleshooting Quick Reference
For each major service, provide:
- `systemctl status <service>`
- `journalctl -u <service> -f`
- Common failure modes specific to this config
- Homepage dashboard URL for status overview
- Grafana dashboard for metrics
- Uptime Kuma for availability history

### 11. Dependencies Map
Create a dependency graph showing:
- PostgreSQL → (blocky, pgadmin)
- Prowlarr → (sonarr, radarr, lidarr, bazarr)
- Transmission → (*arr services for downloading)
- Nginx → (all web services for reverse proxy)
- Cloudflared → (nginx for external access)
- Prometheus → (all exporters)
- Loki → (promtail for logs)

## Output Format

**All documentation must be written to the `/docs` directory in the repository root.**

Structure:
```
/docs/
├── README.md                           # Overview, navigation, scope (thor only for now)
├── thor/
│   ├── README.md                       # Thor overview and quick start
│   ├── system-architecture.md          # Hardware, ZFS, storage
│   ├── network-configuration.md        # IPs, firewall, proxy, DNS
│   ├── storage-and-shares.md           # ZFS, NFS, Samba details
│   ├── services/
│   │   ├── README.md                   # Service inventory table
│   │   ├── media-stack.md              # Jellyfin, Audiobookshelf, Kavita
│   │   ├── arr-stack.md                # All *arr services + Prowlarr
│   │   ├── monitoring-stack.md         # Prometheus, Grafana, Loki, etc.
│   │   ├── download-clients.md         # Transmission configuration
│   │   ├── utilities.md                # Homepage, N8N, etc.
│   │   └── [individual-service].md     # For complex services
│   ├── monitoring-and-alerting.md      # How to check system health
│   ├── backup-and-recovery.md          # Restic + ZFS snapshots
│   ├── troubleshooting-guide.md        # Decision trees, common issues
│   └── security.md                     # Security configuration and concerns
```

Use markdown with:
- Clear headings and table of contents
- Port tables (service → port → URL → purpose)
- Specific NixOS commands (`systemctl`, `journalctl`, `zfs list`, `restic snapshots`)
- Links between docs (e.g., monitoring guide links to specific service docs)
- Code blocks for configuration excerpts

## Important Notes

- **Reference centralized constants**: Don't duplicate port numbers - reference `lib/constants.nix`
- **Flag security concerns**: Samba guest access, services without authentication
- **Highlight monitoring gaps**: Services without Prometheus exporters or health checks
- **Note disabled services**: Deluge and Sabnzbd are disabled - explain why if discernible
- **Agenix secrets**: Note which services use encrypted secrets (e.g., Cloudflared credentials)
- **Impermanence implications**: What's ephemeral vs persisted
- **Cross-references**: Link to actual source files in the repo for technical details

## Analysis Approach

1. Start with `hosts/thor/default.nix` to understand host-specific config
2. Review `roles/homelab.nix` for service inventory
3. Check `lib/constants.nix` for ports, paths, and defaults
4. Examine individual service modules in `/modules/nixos/services/`
5. Review virtualization configs in `/modules/nixos/virtualisation/`
6. Check security and network modules
7. Generate dependency graph from service relationships
8. Create documentation structure
9. Generate markdown files systematically

Begin by exploring the configuration structure, then proceed through each documentation section. Create a comprehensive reference that an AI agent or team member could use to understand, operate, and troubleshoot thor effectively.

---

## Usage Instructions

To regenerate or update documentation:

1. **Ensure you're in the repository root**: `cd /path/to/nilfheim`

2. **Provide this prompt to Claude Code or another AI assistant**

3. **The AI will**:
   - Analyze the configuration files
   - Generate all documentation in `/docs/thor/`
   - Create markdown files with proper cross-references
   - Include actual commands, ports, and URLs from your config

4. **Review and customize**:
   - Update any dynamic information (IPs, passwords, URLs)
   - Add screenshots or diagrams if helpful
   - Verify all commands work in your environment

5. **Commit the documentation**:
   ```bash
   git add docs/
   git commit -m "docs(thor): generate comprehensive server documentation"
   git push
   ```

## Adapting for Other Servers

To document other servers (freya, loki, odin):

1. **Update the scope section** to focus on the target server
2. **Modify configuration paths**:
   - Replace `hosts/thor/` with `hosts/<server>/`
   - Update role reference if different (e.g., `workstation.nix` for freya)
3. **Adjust service inventory** based on what's enabled for that server
4. **Update network details** (IPs, domain, etc.)
5. **Modify output directory**: Change `/docs/thor/` to `/docs/<server>/`

## Configuration-Specific Details

This prompt was tailored for the Nilfheim NixOS configuration with:
- **Centralized constants**: `lib/constants.nix` for ports, paths, descriptions
- **Modular services**: Each service in `modules/nixos/services/<category>/`
- **Role-based deployment**: `roles/homelab.nix` defines service set
- **Impermanence**: Stateless root filesystem with selected persistence
- **ZFS storage**: Two pools (zroot for system, tank for data)
- **Monitoring stack**: Full Prometheus + Grafana + Loki setup
- **Backup strategy**: Restic + ZFS snapshots

If your configuration differs significantly, adjust the prompt accordingly.

---

**Generated**: 2024-10-06
**Configuration Version**: Nilfheim (NixOS flake-based)
**Documentation Coverage**: Thor homelab server
