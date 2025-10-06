# Thor Backup & Recovery

Comprehensive backup strategy using Restic and ZFS snapshots for data protection and disaster recovery.

## Backup Strategy Overview

Thor uses a two-tier backup approach:
1. **ZFS Snapshots**: Fast, local snapshots for `/srv` (service data)
2. **Restic Backups**: Encrypted, deduplicated backups to `/mnt/backup/thor/restic`

```
┌─────────────────────────────────────────────────────────────┐
│                      Data Sources                           │
├─────────────────────────────────────────────────────────────┤
│  /srv (service data)  │  /persist (system state)           │
│  • Prometheus data    │  • SSH keys                        │
│  • Grafana dashboards │  • Machine ID                      │
│  • Loki logs          │  • Network configs                 │
│  • *arr databases     │  • Secrets                         │
│  • Jellyfin metadata  │                                    │
└───────┬───────────────┴────────────────────────────────────┘
        │                           │
        ▼                           ▼
┌──────────────┐          ┌──────────────────┐
│ ZFS Snapshots│          │  Restic Backup   │
│ (local, fast)│          │ (encrypted, full)│
│              │          │                  │
│ zroot/local/ │          │ Repository:      │
│ srv@auto-*   │          │ /mnt/backup/thor/│
│              │          │ restic           │
│ Retention:   │          │                  │
│ • 15min: 4   │          │ Daily schedule   │
│ • hourly: 24 │          │ (systemd timer)  │
│ • daily: 14  │          │                  │
│ • weekly: 8  │          │ Retention:       │
│ • monthly: 6 │          │ • Keep 30 daily  │
└──────────────┘          │ • Keep 12 monthly│
                          │ • Prune auto     │
                          └──────────────────┘
```

## ZFS Snapshots

### Snapshot Configuration

**Dataset**: `zroot/local/srv` (service data)
**Property**: `com.sun:auto-snapshot=true`

**Snapshot Schedule** (from [`lib/constants.nix`](../../lib/constants.nix)):
| Type | Interval | Keep | Retention Window |
|------|----------|------|------------------|
| Frequent | 15 minutes | 4 | 1 hour |
| Hourly | 1 hour | 24 | 24 hours |
| Daily | 1 day | 14 | 2 weeks |
| Weekly | 1 week | 8 | 2 months |
| Monthly | 1 month | 6 | 6 months |

**Service**: `zfs-auto-snapshot` (systemd timers)

### Viewing Snapshots

```bash
# List all snapshots for /srv
zfs list -t snapshot zroot/local/srv

# List with creation time and size
zfs list -t snapshot -o name,creation,used zroot/local/srv

# Browse snapshot contents
ls /srv/.zfs/snapshot/

# View specific snapshot
ls /srv/.zfs/snapshot/auto-daily-2024-10-06/
```

### Restoring from ZFS Snapshots

**Restore Individual Files**:
```bash
# List available snapshots
ls /srv/.zfs/snapshot/

# Copy file from snapshot
cp /srv/.zfs/snapshot/auto-hourly-2024-10-06-12h00/grafana/grafana.db /srv/grafana/

# Restore directory
rsync -av /srv/.zfs/snapshot/auto-daily-2024-10-05/sonarr/ /srv/sonarr/
```

**Rollback Entire Dataset** (⚠️ **DESTRUCTIVE** - destroys all data newer than snapshot):
```bash
# List snapshots
zfs list -t snapshot zroot/local/srv

# Rollback to snapshot
sudo zfs rollback zroot/local/srv@auto-daily-2024-10-05

# Rollback with force (destroys intermediate snapshots)
sudo zfs rollback -r zroot/local/srv@auto-daily-2024-10-05
```

### Managing Snapshots

**Manual Snapshot**:
```bash
# Create manual snapshot
sudo zfs snapshot zroot/local/srv@manual-$(date +%Y%m%d-%H%M%S)

# Delete manual snapshot
sudo zfs destroy zroot/local/srv@manual-20241006-120000
```

**Snapshot Cleanup** (automatic via `zfs-auto-snapshot`, manual if needed):
```bash
# Delete old snapshots (example: older than 30 days)
zfs list -t snapshot -o name,creation | \
  awk '$2 < "'$(date -d '30 days ago' '+%Y-%m-%d')'" {print $1}' | \
  xargs -r -n1 sudo zfs destroy
```

### ZFS Send/Receive (Off-site Replication)

**Send Snapshot to File**:
```bash
# Full snapshot
sudo zfs send zroot/local/srv@auto-daily-2024-10-06 > /mnt/backup/srv-snapshot.zfs

# Incremental snapshot
sudo zfs send -i @auto-daily-2024-10-05 zroot/local/srv@auto-daily-2024-10-06 > /mnt/backup/srv-incremental.zfs
```

**Receive Snapshot**:
```bash
# Receive to new dataset
sudo zfs receive tank/srv-restore < /mnt/backup/srv-snapshot.zfs

# Verify
zfs list tank/srv-restore
```

## Restic Backups

### Backup Configuration

**Repository**: `/mnt/backup/thor/restic`
**Schedule**: Daily (systemd timer: `restic-backups-system.timer`)
**Service**: `restic-backups-system.service`

**Configuration Reference**: [`roles/homelab.nix`](../../roles/homelab.nix) (services.backup.restic)

### Backup Status

**Check Backup Service**:
```bash
# Check backup timer status
systemctl status restic-backups-system.timer
systemctl list-timers | grep restic

# Check last backup run
systemctl status restic-backups-system.service

# View backup logs
journalctl -u restic-backups-system.service -n 100

# Follow backup progress (during backup)
journalctl -u restic-backups-system.service -f
```

### Manual Backup Operations

**Set Environment**:
```bash
export RESTIC_REPOSITORY=/mnt/backup/thor/restic
export RESTIC_PASSWORD_FILE=/etc/restic/password
```

**List Snapshots**:
```bash
restic snapshots
restic snapshots --compact
```

**Repository Statistics**:
```bash
# Overall stats
restic stats

# Latest snapshot stats
restic stats latest

# Repository size
restic stats --mode raw-data
```

**Run Manual Backup**:
```bash
# Trigger immediate backup
sudo systemctl start restic-backups-system.service

# Or manually (with correct paths)
sudo restic -r /mnt/backup/thor/restic backup /srv /persist
```

### Restoring from Restic

**List Snapshot Contents**:
```bash
# List files in latest snapshot
restic ls latest

# List specific path
restic ls latest /srv/grafana

# Find specific file
restic find "grafana.db"
```

**Restore Files**:
```bash
# Restore specific file
restic restore latest --target /tmp/restore --include /srv/grafana/grafana.db

# Restore entire directory
restic restore latest --target /tmp/restore --include /srv/sonarr

# Restore everything
restic restore latest --target /tmp/restore

# Restore specific snapshot
restic restore abc123def --target /tmp/restore
```

**Example Restore Workflow**:
```bash
# 1. Find snapshot
restic snapshots

# 2. List contents
restic ls abc123def /srv/grafana

# 3. Restore to temporary location
restic restore abc123def --target /tmp/restore --include /srv/grafana

# 4. Stop service
sudo systemctl stop grafana

# 5. Replace files
sudo rsync -av /tmp/restore/srv/grafana/ /srv/grafana/

# 6. Fix permissions
sudo chown -R grafana:grafana /srv/grafana

# 7. Restart service
sudo systemctl start grafana

# 8. Verify
systemctl status grafana
```

### Repository Maintenance

**Check Repository Integrity**:
```bash
# Quick check
restic check

# Thorough check (reads data)
restic check --read-data-subset=10%

# Full check (slow)
restic check --read-data
```

**Prune Old Snapshots** (automatic, but can be manual):
```bash
# Prune according to policy
restic forget --keep-daily 30 --keep-monthly 12 --prune

# Dry run (see what would be deleted)
restic forget --keep-daily 30 --keep-monthly 12 --dry-run
```

**Unlock Repository** (if locked due to crash):
```bash
restic unlock
```

### Monitoring Backups

**Prometheus Metrics** (if configured):
- `restic_backup_duration_seconds` - Backup duration
- `restic_backup_files_total` - Number of files backed up
- `restic_backup_size_bytes` - Backup size

**Log-based Monitoring** (Loki):
```logql
{job="systemd-journal", unit="restic-backups-system.service"}
{job="systemd-journal", unit="restic-backups-system.service"} |= "ERROR"
{job="systemd-journal", unit="restic-backups-system.service"} |= "completed"
```

**Alert on Backup Failure** (configure in Prometheus):
- No successful backup in 48 hours
- Backup duration exceeds threshold
- Repository errors detected

## Disaster Recovery Procedures

### Scenario 1: Service Data Corruption

**If detected within snapshot retention window (up to 6 months)**:

1. Stop affected service
2. Identify last good snapshot: `ls /srv/.zfs/snapshot/`
3. Restore from snapshot (see ZFS Restore above)
4. Restart service
5. Verify functionality

**If outside snapshot window**:
1. Use Restic to restore from backup
2. Follow Restic restore procedure above

### Scenario 2: Complete /srv Dataset Loss

1. Boot into rescue mode or rebuild system
2. Restore from Restic backup:
   ```bash
   restic restore latest --target / --include /srv
   ```
3. Fix permissions (service-specific)
4. Restart services
5. Verify all services operational

### Scenario 3: Full System Rebuild

1. **Reinstall NixOS** with same disko configuration
2. **Restore zroot/local/persist**:
   ```bash
   restic restore latest --target / --include /persist
   ```
3. **Restore zroot/local/srv**:
   ```bash
   restic restore latest --target / --include /srv
   ```
4. **Deploy NixOS configuration**:
   ```bash
   nixos-rebuild switch --flake .#thor
   ```
5. **Verify services**: `systemctl status`

### Scenario 4: ZFS Pool Failure (tank)

1. Replace failed disk
2. **If pool is intact**: `zpool replace tank /dev/sda /dev/sdb`
3. **If pool is destroyed**:
   - Recreate pool: `zpool create tank /dev/sdb`
   - Recreate datasets (via disko or manual)
   - Restore media from backups or external sources

**Note**: Media files are typically NOT in Restic backups (too large). Ensure you have off-site media backups or accept data loss.

## Backup Best Practices

### What's Backed Up
✅ **Included**:
- `/srv` - All service data (databases, configs, metadata)
- `/persist` - System state (SSH keys, machine ID, network configs)

❌ **Excluded**:
- `/nix` - Reproducible from configuration
- `/` (root) - Ephemeral (impermanence)
- `/mnt/media` - Too large, should have separate backup strategy
- `/mnt/downloads` - Transient data

### Backup Testing

**Monthly Test**:
1. List recent snapshots: `restic snapshots`
2. Test restore to temp location
3. Verify data integrity
4. Document test results

**Quarterly Full Test**:
1. Perform full VM restore test
2. Verify all services start correctly
3. Test service functionality
4. Update disaster recovery documentation

### Off-site Backups

⚠️ **Current State**: Backups are stored locally on `tank/backup`

**Recommendations**:
1. Configure Restic remote repository (S3, B2, rsync.net)
2. Add off-site replication of critical data
3. Test off-site restore procedure
4. Consider 3-2-1 backup rule:
   - 3 copies of data
   - 2 different media types
   - 1 off-site copy

## Monitoring Backup Health

### Grafana Dashboard Panels
- Backup success rate
- Backup duration trend
- Repository size growth
- Last successful backup time

### Alerts to Configure
- 🚨 **Critical**: No successful backup in 48 hours
- ⚠️ **Warning**: Backup duration increasing (>2x baseline)
- ⚠️ **Warning**: Repository disk space low (<20%)
- 🚨 **Critical**: Backup service failed

### Backup Checklist

**Daily** (automated):
- [ ] Restic backup runs successfully
- [ ] ZFS snapshots created on schedule

**Weekly** (manual):
- [ ] Review backup logs for errors
- [ ] Check backup repository size
- [ ] Verify recent snapshots exist

**Monthly** (manual):
- [ ] Test restore from Restic
- [ ] Run `restic check`
- [ ] Review retention policy
- [ ] Check ZFS snapshot count

**Quarterly** (manual):
- [ ] Full disaster recovery test
- [ ] Update documentation
- [ ] Review backup strategy
- [ ] Audit what's backed up vs what should be

## Related Documentation
- [🗄️ Storage & Shares](storage-and-shares.md) - ZFS pool configuration
- [🏗️ System Architecture](system-architecture.md) - Impermanence and persistence
- [📊 Monitoring](monitoring-and-alerting.md) - Backup monitoring
- [🔙 Back to Thor Overview](README.md)

---

**Configuration Sources**:
- [`roles/homelab.nix`](../../roles/homelab.nix) (services.backup.restic)
- [`lib/constants.nix`](../../lib/constants.nix) (snapshotRetention)
- ZFS auto-snapshot: System service (zfs-auto-snapshot)
