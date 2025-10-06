# Thor Services Inventory

Complete catalog of all services running on thor, organized by category with ports, URLs, and operational details.

## Quick Reference Table

### Media Services 🎬

| Service | Port | URL | Purpose | Data Location | Critical |
|---------|------|-----|---------|---------------|----------|
| Jellyfin | 8096 | https://jellyfin.greensroad.uk | Media streaming server | /srv/jellyfin | ⭐ High |
| Jellyseerr | 5055 | https://jellyseerr.greensroad.uk | Media request management | /srv/jellyseerr | Medium |
| Audiobookshelf | 8000 | https://audiobookshelf.greensroad.uk | Audiobook/podcast server | /srv/audiobookshelf | Medium |
| Kavita | 5000 | https://kavita.greensroad.uk | Digital library (comics/ebooks) | /srv/kavita | Medium |

### Download Management 📥

| Service | Port | URL | Purpose | Data Location | Critical |
|---------|------|-----|---------|---------------|----------|
| Sonarr | 8989 | https://sonarr.greensroad.uk | TV series automation | /srv/sonarr | ⭐ High |
| Radarr | 7878 | https://radarr.greensroad.uk | Movie automation | /srv/radarr | ⭐ High |
| Lidarr | 8686 | https://lidarr.greensroad.uk | Music automation | /srv/lidarr | Medium |
| Bazarr | 6767 | https://bazarr.greensroad.uk | Subtitle management | /srv/bazarr | Low |
| Prowlarr | 9696 | https://prowlarr.greensroad.uk | Indexer manager (central) | /srv/prowlarr | ⭐ Critical |
| Transmission | 9091 | http://localhost:9091 | BitTorrent client | /srv/transmission | ⭐ High |
| Recyclarr | - | - | *arr config sync (cron) | /srv/recyclarr | Low |
| Flaresolverr | - | http://localhost:8191 | Cloudflare bypass proxy | - | Medium |

**Note**: Deluge (8112) and Sabnzbd (8080) are **disabled** in current configuration

### Monitoring Stack 📊

| Service | Port | URL | Purpose | Data Location | Critical |
|---------|------|-----|---------|---------------|----------|
| Prometheus | 9090 | https://prometheus.greensroad.uk | Metrics collection | /srv/prometheus | ⭐ Critical |
| Grafana | 3000 | https://grafana.greensroad.uk | Visualization dashboards | /srv/grafana | ⭐ Critical |
| Loki | 3100 | https://loki.greensroad.uk | Log aggregation | /srv/loki | ⭐ Critical |
| Promtail | 9080 | http://localhost:9080 | Log collection agent | - | High |
| Alertmanager | 9093 | https://alertmanager.greensroad.uk | Alert routing | /srv/alertmanager | High |
| Uptime Kuma | 3001 | https://uptime-kuma.greensroad.uk | Uptime monitoring | /srv/uptime-kuma | High |
| Glances | 61208 | https://glances.greensroad.uk | System monitoring | - | Medium |

### Prometheus Exporters 📈

| Exporter | Port | Purpose | Config Location |
|----------|------|---------|-----------------|
| node-exporter | 9100 | System metrics (CPU, memory, disk, network) | Built-in |
| smartctl-exporter | 9633 | Disk health (SMART) | /dev/nvme0, /dev/sda |
| zfs-exporter | - | ZFS pool/dataset metrics | zroot, tank |
| exportarr-sonarr | 9709 | Sonarr metrics | Scrapes Sonarr API |
| exportarr-radarr | 9711 | Radarr metrics | Scrapes Radarr API |
| exportarr-lidarr | 9710 | Lidarr metrics | Scrapes Lidarr API |
| exportarr-bazarr | 9712 | Bazarr metrics | Scrapes Bazarr API |
| exportarr-prowlarr | 9713 | Prowlarr metrics | Scrapes Prowlarr API |

### Utility Services 🔧

| Service | Port | URL | Purpose | Data Location | Critical |
|---------|------|-----|---------|---------------|----------|
| Homepage | 3002 | https://homepage.greensroad.uk | Service dashboard | /srv/homepage | ⭐ High |
| N8N | 5678 | https://n8n.greensroad.uk | Workflow automation | /srv/n8n | Medium |
| Code Server | 8443 | https://code-server.greensroad.uk | VS Code in browser | /srv/code-server | Low |
| Stirling PDF | 8081 | https://stirling-pdf.greensroad.uk | PDF tools | /srv/stirling-pdf | Low |
| Karakeep | 8090 | https://karakeep.greensroad.uk | Karaoke management | /srv/karakeep | Low |
| Mealie | 9000 | https://mealie.greensroad.uk | Recipe manager | /srv/mealie | Low |

### Database Services 🗄️

| Service | Port | URL | Purpose | Data Location | Critical |
|---------|------|-----|---------|---------------|----------|
| PostgreSQL | 5432 | localhost only | Database server | /srv/postgresql | ⭐ Critical |
| pgAdmin | 5050 | https://pgadmin.greensroad.uk | PostgreSQL web admin | /srv/pgadmin | Medium |

**PostgreSQL Clients**: Blocky (DNS query logging), pgAdmin

### Network Services 🌐

| Service | Port | Purpose | Network Access | Critical |
|---------|------|---------|----------------|----------|
| Nginx | 80, 443 | Reverse proxy | All interfaces | ⭐ Critical |
| Blocky | 4000 | DNS proxy/ad-blocker | Local only | ⭐ Critical |
| Cloudflared | - | Secure tunnel (ID: 23c4423f...) | External | ⭐ Critical |
| Tailscale | 41641 | Mesh VPN | All interfaces | ⭐ Critical |
| NFS Server | 2049, 111, 20048 | Network file shares | Tailscale only | High |
| Samba | 445 | SMB file shares | LAN + Tailscale | High |
| Avahi | 5353 | mDNS/service discovery | LAN | Medium |
| SSH | 22 | Secure remote access | All interfaces | ⭐ Critical |

### Container Services 🐳

| Service | Runtime | Port | Purpose | Data Location | Critical |
|---------|---------|------|---------|---------------|----------|
| Home Assistant | Podman | 8123 | Home automation | /srv/homeassistant | Medium |
| Tdarr | Podman | - | Media transcoding | /srv/tdarr | Low |

### Security Services 🔒

| Service | Purpose | Configuration |
|---------|---------|---------------|
| Fail2ban | Intrusion prevention | SSH, Nginx HTTP auth |

### Backup Services 💾

| Service | Purpose | Repository | Schedule |
|---------|---------|------------|----------|
| Restic | Automated backups | /mnt/backup/thor/restic | Daily (systemd timer) |
| ZFS Auto-Snapshot | /srv snapshots | zroot/local/srv | 15min, hourly, daily, weekly, monthly |

## Service Dependencies

### Critical Dependency Chain
```
PostgreSQL
  └─→ Blocky (DNS logging)
  └─→ pgAdmin

Prowlarr (Indexer Manager)
  └─→ Sonarr
  └─→ Radarr
  └─→ Lidarr
  └─→ Bazarr

Transmission (Download Client)
  └─→ Sonarr
  └─→ Radarr
  └─→ Lidarr

Nginx (Reverse Proxy)
  └─→ ALL web services

Cloudflared (External Access)
  └─→ Nginx

Prometheus (Metrics)
  └─→ All exporters
  └─→ Grafana (data source)
  └─→ Alertmanager

Loki (Logs)
  └─→ Promtail (log shipper)
  └─→ Grafana (data source)
```

### Startup Order (Systemd)
1. **Base Layer**: PostgreSQL, ZFS pools
2. **Network Layer**: Tailscale, Nginx, Cloudflared
3. **Core Services**: Prometheus, Loki, Blocky
4. **Application Layer**: Media services, *arr stack
5. **Monitoring Layer**: Promtail, exporters, Grafana

## Service Management

### Common Operations

**Check Service Status**:
```bash
systemctl status <service>
systemctl status jellyfin
systemctl status sonarr
```

**View Service Logs**:
```bash
journalctl -u <service> -f
journalctl -u transmission -n 100
```

**Restart Service**:
```bash
sudo systemctl restart <service>
```

**Enable/Disable Service**:
```bash
sudo systemctl enable <service>
sudo systemctl disable <service>
```

### Service Configuration Locations

All services are configured declaratively via NixOS:
- **Service Modules**: `modules/nixos/services/<category>/<service>.nix`
- **Enabled Services**: `roles/homelab.nix` (lines 36-97)
- **Port Assignments**: `lib/constants.nix` (ports section)
- **Service Descriptions**: `lib/constants.nix` (descriptions section)

### Rebuilding After Configuration Changes
```bash
# Local rebuild (on thor)
sudo nixos-rebuild switch --flake .#thor

# Remote rebuild (from another machine)
just thor

# Check for failures after rebuild
systemctl --failed
```

## Service Health Monitoring

### Dashboard Access
- **Homepage**: https://homepage.greensroad.uk - All services with status indicators
- **Grafana**: https://grafana.greensroad.uk - Metrics dashboards
- **Uptime Kuma**: https://uptime-kuma.greensroad.uk - Historical uptime
- **Glances**: https://glances.greensroad.uk - Real-time system stats

### Quick Health Check
```bash
# Check all failed services
systemctl --failed

# Check specific service
systemctl status <service>

# View recent logs
journalctl -u <service> -n 50

# Check disk space (service data)
df -h /srv
du -sh /srv/*

# Check ZFS pool health
zpool status
```

### Service Resource Usage
```bash
# View service resource consumption
systemd-cgtop

# Specific service resource usage
systemctl show <service> | grep -E "Memory|CPU"

# Process tree
ps aux | grep <service>
```

## Troubleshooting

### Service Won't Start
1. Check status: `systemctl status <service>`
2. View logs: `journalctl -u <service> -n 100`
3. Check dependencies: `systemctl list-dependencies <service>`
4. Verify configuration: Review service module in `modules/nixos/services/`
5. Check file permissions: `ls -la /srv/<service>`

### Service Performance Issues
1. Check resource usage: `systemd-cgtop`
2. View metrics: Grafana dashboards
3. Check disk I/O: `iostat -x 1`
4. Review logs for errors: `journalctl -u <service> | grep -i error`

### Port Conflicts
All ports are defined in `lib/constants.nix` with automatic conflict detection at build time.

If a service fails to bind to a port:
```bash
# Check what's listening on the port
sudo ss -tulpn | grep <port>

# Kill conflicting process (if necessary)
sudo kill <PID>
```

## Service-Specific Documentation

For detailed documentation on individual services, see:
- [Media Stack](media-stack.md) - Jellyfin, Audiobookshelf, Kavita
- [Arr Stack](arr-stack.md) - Sonarr, Radarr, Lidarr, Bazarr, Prowlarr
- [Monitoring Stack](monitoring-stack.md) - Prometheus, Grafana, Loki, exporters
- [Download Clients](download-clients.md) - Transmission configuration

## Related Documentation
- [📊 Monitoring & Alerting](../monitoring-and-alerting.md)
- [🔧 Troubleshooting Guide](../troubleshooting-guide.md)
- [🔒 Security](../security.md)
- [🔙 Back to Thor Overview](../README.md)

---

**Configuration Sources**:
- [`roles/homelab.nix`](../../../roles/homelab.nix)
- [`modules/nixos/services/`](../../../modules/nixos/services/)
- [`lib/constants.nix`](../../../lib/constants.nix)
