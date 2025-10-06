# Thor Storage & Network Shares

Detailed documentation for ZFS storage pools, datasets, network file shares (NFS/Samba), and storage management on thor.

## Table of Contents
- [ZFS Pool Overview](#zfs-pool-overview)
- [ZFS Management](#zfs-management)
- [NFS Exports](#nfs-exports)
- [Samba Shares](#samba-shares)
- [Storage Monitoring](#storage-monitoring)
- [Maintenance Procedures](#maintenance-procedures)

## ZFS Pool Overview

Thor uses two ZFS pools for separation of system and data storage:

| Pool | Device | Purpose | Compression | Size |
|------|--------|---------|-------------|------|
| **zroot** | /dev/nvme0n1 | System, services | lz4 (fast) | Variable (NVMe) |
| **tank** | /dev/sda | Media, downloads, backups | zstd (efficient) | Variable (HDD) |

### Pool Health Status
```bash
# Check pool status
zpool status

# Check pool capacity
zpool list

# View I/O statistics
zpool iostat 1
```

## ZFS Datasets

### zroot Pool (System Storage)

```
zroot
└── local (no mountpoint)
    ├── root      → /          (ephemeral, resets on boot)
    ├── nix       → /nix       (Nix store, persistent)
    ├── persist   → /persist   (system state, persistent)
    └── srv       → /srv       (service data, persistent, auto-snapshot)
```

| Dataset | Mountpoint | Snapshots | Persistent | Purpose |
|---------|------------|-----------|------------|---------|
| `zroot/local/root` | / | ❌ | ❌ | Root filesystem (ephemeral via impermanence) |
| `zroot/local/nix` | /nix | ❌ | ✅ | Nix store (packages and derivations) |
| `zroot/local/persist` | /persist | ❌ | ✅ | System persistence (SSH keys, machine ID) |
| `zroot/local/srv` | /srv | ✅ | ✅ | Service data directories |

**Key Configuration**:
- **Compression**: lz4 (optimized for low-latency workloads)
- **Atime**: disabled (performance optimization)
- **Ashift**: 12 (4K sector size)

**Blank Snapshot**: `zroot/local/root@blank` created on first boot, root rolled back to this snapshot on every boot

### tank Pool (Data Storage)

```
tank
├── backup    → /mnt/backup       (Restic repository)
├── share     → /mnt/share        (general file share)
├── media     → /mnt/media        (media library)
└── downloads → /mnt/downloads    (download staging)
```

| Dataset | Mountpoint | Snapshots | Mount Opts | Purpose |
|---------|------------|-----------|------------|---------|
| `tank/backup` | /mnt/backup | ❌ | nofail | Backup storage (Restic repository) |
| `tank/share` | /mnt/share | ❌ | nofail | General file sharing |
| `tank/media` | /mnt/media | ❌ | nofail | Media library (movies, TV, music, etc.) |
| `tank/downloads` | /mnt/downloads | ❌ | nofail | Download staging (torrents, usenet) |

**Key Configuration**:
- **Compression**: zstd (better compression for large files)
- **Atime**: disabled
- **Mount Options**: nofail (system boots even if datasets fail to mount)

## ZFS Management

### Viewing Datasets
```bash
# List all datasets
zfs list

# Show dataset properties
zfs get all zroot/local/srv

# Check compression ratios
zfs get compressratio

# View space usage by dataset
zfs list -o name,used,avail,refer,mountpoint
```

### Snapshot Management

**Automatic Snapshots** (only for `/srv`):
```bash
# List snapshots for srv dataset
zfs list -t snapshot zroot/local/srv

# View snapshot schedule
systemctl list-timers | grep zfs-auto-snapshot
```

**Manual Snapshots**:
```bash
# Create snapshot
sudo zfs snapshot zroot/local/srv@manual-$(date +%Y%m%d-%H%M%S)

# List snapshots
zfs list -t snapshot

# Delete snapshot
sudo zfs destroy zroot/local/srv@snapshot-name

# Rollback to snapshot (DANGEROUS - destroys newer data)
sudo zfs rollback zroot/local/srv@snapshot-name
```

**Snapshot Retention** (from [`lib/constants.nix`](../../lib/constants.nix)):
| Type | Interval | Keep | Total Retention |
|------|----------|------|-----------------|
| Frequent | 15 min | 4 | 1 hour |
| Hourly | 1 hour | 24 | 1 day |
| Daily | 1 day | 14 | 2 weeks |
| Weekly | 1 week | 8 | 2 months |
| Monthly | 1 month | 6 | 6 months |

### Snapshot Restoration
```bash
# Browse snapshot contents
ls /srv/.zfs/snapshot/

# List available snapshots
ls /srv/.zfs/snapshot/

# Copy file from snapshot
cp /srv/.zfs/snapshot/auto-daily-2024-10-06/service/file.txt /srv/service/

# Restore entire directory from snapshot
rsync -av /srv/.zfs/snapshot/auto-daily-2024-10-06/grafana/ /srv/grafana/
```

### ZFS Scrubbing
**Purpose**: Verify data integrity and repair any corruption

```bash
# Start scrub
sudo zpool scrub zroot
sudo zpool scrub tank

# Check scrub progress
zpool status

# Stop ongoing scrub
sudo zpool scrub -s zroot
```

**Recommendation**: Run scrubs monthly for critical pools

### Pool Maintenance
```bash
# Check pool health
zpool status -v

# View detailed pool properties
zpool get all zroot

# Clear errors (after fixing underlying issue)
sudo zpool clear zroot

# Export pool (unmount, for maintenance)
sudo zpool export tank

# Import pool
sudo zpool import tank
```

## NFS Exports

Thor exports ZFS datasets to the Tailscale network for access by other machines (primarily freya).

### Exported Shares

| Share Name | Source Path | Permissions | Network | Purpose |
|------------|-------------|-------------|---------|---------|
| downloads | /mnt/downloads | RW | Tailscale | Download staging area |
| media | /mnt/media | RO | Tailscale | Media library (read-only) |
| backup | /mnt/backup | RW | Tailscale | Backup storage |
| share | /mnt/share | RW | Tailscale | General file sharing |

**Network Restriction**: Exports are restricted to the Tailscale network (100.64.0.0/10)

**Configuration Reference**: [`hosts/thor/default.nix`](../../hosts/thor/default.nix) (services.nfs-server)

### NFS Client Access (Freya)

**Mount on freya** (automatically via NixOS config):
```nix
services.nfs-client = {
  enable = true;
  server = "thor";  # MagicDNS hostname
  mounts = {
    media = {
      remotePath = "/media";
      localPath = "/mnt/media";
      options = ["soft" "intr" "bg" "vers=4" "ro"];
    };
    # ... other mounts
  };
};
```

**Manual Mount** (for testing):
```bash
# Mount NFS share
sudo mount -t nfs -o soft,intr,bg,vers=4 thor:/media /mnt/media

# Unmount
sudo umount /mnt/media

# Check mounted NFS shares
mount | grep nfs
```

### NFS Firewall Ports
- **2049/TCP**: NFS protocol
- **111/TCP**: RPC port mapper (rpcbind)
- **20048/TCP**: NFS status monitor

**Access**: Restricted to `tailscale0` interface only

### NFS Monitoring
```bash
# Check NFS server status
systemctl status nfs-server

# View active NFS connections
sudo showmount -a

# View exported shares
sudo exportfs -v

# Check RPC services
rpcinfo -p
```

## Samba Shares

Thor provides SMB/CIFS shares for Windows and macOS clients.

### Samba Share Configuration

| Share Name | Path | Read Only | Guest Access | Force User | Force Group |
|------------|------|-----------|--------------|------------|-------------|
| downloads | /mnt/downloads | No | Yes | ed | tank |
| media | /mnt/media | Yes | Yes | ed | tank |
| backup | /mnt/backup | No | Yes | ed | tank |
| share | /mnt/share | No | Yes | ed | tank |

**Configuration Reference**: [`hosts/thor/default.nix`](../../hosts/thor/default.nix) (services.samba)

### File Permissions
- **Create Mask**: 0644 (rw-r--r--)
- **Directory Mask**: 0755 (rwxr-xr-x)
- **Owner**: Set to `ed:tank` via force user/group

### Accessing Samba Shares

**From Windows**:
```
\\thor\downloads
\\thor\media
\\thor\backup
\\thor\share
```

**From macOS**:
```
smb://thor/downloads
smb://thor/media
smb://thor/backup
smb://thor/share
```

**From Linux**:
```bash
# Mount Samba share
sudo mount -t cifs //thor/media /mnt/media -o guest

# Using smbclient
smbclient //thor/media -U guest

# List shares
smbclient -L thor -U guest
```

### Samba Monitoring
```bash
# Check Samba status
systemctl status smbd

# View connected clients
sudo smbstatus

# View open files
sudo smbstatus -f

# Monitor Samba logs
journalctl -u smbd -f
```

### Security Considerations

⚠️ **Guest Access Enabled**: All shares allow guest (unauthenticated) access

**Recommendations**:
1. Restrict Samba to Tailscale network only (currently accessible on LAN)
2. Disable guest access and require authentication
3. Use separate user accounts with strong passwords
4. Enable Samba audit logging

**Current Risk**: Anyone on the LAN can access all shares without authentication

## Storage Monitoring

### Capacity Monitoring
```bash
# Check overall disk usage
df -h

# ZFS-specific capacity
zfs list -o name,used,avail,refer

# Pool capacity
zpool list

# Dataset quotas (if configured)
zfs get quota,used,available
```

### Performance Monitoring
```bash
# Pool I/O statistics
zpool iostat 1

# ARC (cache) statistics
arcstat 1

# Disk I/O
iostat -x 1

# ZFS transaction group (TXG) stats
zpool iostat -v 1
```

### Health Monitoring
```bash
# Pool health
zpool status

# Scrub status
zpool status | grep scrub

# SMART disk health
sudo smartctl -a /dev/nvme0
sudo smartctl -a /dev/sda

# Check for ZFS errors
zpool status -x
```

### Prometheus Exporters
- **ZFS Exporter**: Exposes pool and dataset metrics (zpool_health, dataset_used, etc.)
- **SMART Exporter**: Monitors disk health (/dev/nvme0, /dev/sda)
- **Node Exporter**: General disk metrics (disk_io, filesystem usage)

**Grafana Dashboards**: https://grafana.greensroad.uk

## Maintenance Procedures

### Regular Maintenance Tasks

**Weekly**:
- Review storage capacity: `df -h && zfs list`
- Check pool status: `zpool status`

**Monthly**:
- Run ZFS scrub: `sudo zpool scrub zroot && sudo zpool scrub tank`
- Review SMART health: `sudo smartctl -a /dev/nvme0 && sudo smartctl -a /dev/sda`
- Clean up old downloads: Review `/mnt/downloads`

**Quarterly**:
- Review snapshot retention policies
- Prune old Restic backups (automatic, verify)
- Audit NFS/Samba access logs

### Adding New Datasets
```bash
# Create new dataset
sudo zfs create tank/newdataset

# Set mountpoint
sudo zfs set mountpoint=/mnt/newdataset tank/newdataset

# Set compression
sudo zfs set compression=zstd tank/newdataset

# Enable snapshots
sudo zfs set com.sun:auto-snapshot=true tank/newdataset

# Set permissions
sudo chown -R root:tank /mnt/newdataset
sudo chmod 2775 /mnt/newdataset
```

### Expanding Storage

**Add new disk to pool**:
```bash
# Attach mirror (for redundancy)
sudo zpool attach tank /dev/sda /dev/sdb

# Add new vdev (increases capacity, no redundancy)
sudo zpool add tank /dev/sdb

# Check status
zpool status tank
```

**Note**: ZFS pool topology cannot be changed after creation (no shrinking, limited expansion)

### Disaster Recovery

**Pool Export/Import** (for moving disks to another system):
```bash
# Export pool (unmount cleanly)
sudo zpool export tank

# Import pool on new system
sudo zpool import tank

# Import pool with different name
sudo zpool import tank newtank

# Force import (if pool was not cleanly exported)
sudo zpool import -f tank
```

**Dataset Replication** (send/receive):
```bash
# Send snapshot to file
sudo zfs send zroot/local/srv@snapshot > /mnt/backup/srv-snapshot.zfs

# Receive snapshot
sudo zfs receive tank/srv-backup < /mnt/backup/srv-snapshot.zfs

# Incremental send (efficient)
sudo zfs send -i @old-snapshot zroot/local/srv@new-snapshot > /mnt/backup/incremental.zfs
```

## Storage Capacity Planning

### Current Usage (Example - check actual values)
```bash
# Get current usage
zfs list -o name,used,avail,refer | grep -E "zroot|tank"
```

### Growth Estimates
- **Nix Store (`/nix`)**: Grows with package updates (10-50GB typical)
- **Service Data (`/srv`)**: Varies by service (Prometheus, Grafana, Loki logs)
- **Media (`tank/media`)**: Large files, depends on collection size
- **Downloads (`tank/downloads`)**: Transient, should be cleaned regularly
- **Backups (`tank/backup`)**: Grows with backup retention policy

### Capacity Alerts
Set up alerts in Prometheus/Alertmanager:
- ⚠️ Warning: 80% capacity
- 🚨 Critical: 90% capacity

**Configuration**: Check Prometheus rules in [`modules/nixos/services/monitoring/prometheus.nix`](../../modules/nixos/services/monitoring/prometheus.nix)

## Troubleshooting Storage Issues

### Pool Won't Import
```bash
# Check if pool is exported
zpool import

# Force import
sudo zpool import -f tank

# Import by pool ID
sudo zpool import -d /dev <pool-id> tank
```

### Disk Errors
```bash
# Check pool errors
zpool status -v

# Check SMART status
sudo smartctl -a /dev/sda

# Clear transient errors (after verifying disk health)
sudo zpool clear tank
```

### Out of Space
```bash
# Find large files
du -sh /srv/* | sort -h
du -sh /mnt/media/* | sort -h

# Check snapshots (can consume space)
zfs list -t snapshot -o name,used,refer

# Delete old snapshots
sudo zfs destroy zroot/local/srv@old-snapshot

# Cleanup Nix store
nix-collect-garbage --delete-older-than 30d
```

### NFS Mount Issues
```bash
# Check NFS server
systemctl status nfs-server

# Verify exports
sudo exportfs -v

# Check firewall (on thor)
sudo iptables -L -v -n | grep -E "2049|111|20048"

# Test connectivity from client
showmount -e thor
```

### Samba Issues
```bash
# Check Samba status
systemctl status smbd

# Test Samba configuration
testparm -s

# View Samba logs
journalctl -u smbd -f

# Restart Samba
sudo systemctl restart smbd
```

## Related Documentation
- [🏗️ System Architecture](system-architecture.md) - ZFS pool design
- [💾 Backup & Recovery](backup-and-recovery.md) - Restic backups and snapshot restoration
- [🌐 Network Configuration](network-configuration.md) - NFS/Samba network access
- [🔙 Back to Thor Overview](README.md)

---

**Configuration Sources**:
- [`hosts/thor/default.nix`](../../hosts/thor/default.nix)
- [`hosts/thor/disko-configuration.nix`](../../hosts/thor/disko-configuration.nix)
- [`modules/nixos/services/network/nfs.nix`](../../modules/nixos/services/network/nfs.nix)
- [`modules/nixos/services/utilities/samba.nix`](../../modules/nixos/services/utilities/samba.nix)
