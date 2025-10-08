# Backup Operations

Complete guide for managing Restic backups in Nilfheim.

## Overview

Nilfheim uses Restic for encrypted, deduplicated backups with the following configuration:

- **Thor**: `/persist` and `/srv` → `/mnt/backup/thor/restic`
- **Freya**: `/persist` and `/home` → `/mnt/backup/freya/restic`
- **Schedule**: Daily with randomized delay
- **Retention**: 14 daily, 8 weekly, 6 monthly, 2 yearly
- **Monitoring**: Logs aggregated via Loki with Grafana dashboards

## Checking Backup Status

### Service Status

```bash
# Check backup service status
systemctl status restic-backups-system.service
systemctl status restic-backups-system.timer

# List scheduled backup timers
systemctl list-timers | grep restic
```

### View Backup Logs

```bash
# Follow live backup logs
journalctl -u restic-backups-system.service -f

# View recent backup history
journalctl -u restic-backups-system.service --since "24 hours ago"

# Check last backup completion
journalctl -u restic-backups-system.service | grep -E "(completed|finished|failed)"
```

### Grafana Dashboard

Access the Restic Backup Monitoring dashboard:

```
https://grafana.${domain}/d/restic-backup/restic-backup-monitoring
```

**Available Metrics:**
- Backup completion status
- Duration and timing
- Repository size and growth
- Error and warning detection

### Loki Log Queries

```bash
# All backup logs
{job="systemd-journal", unit="restic-backups-system.service"}

# Errors only
{job="systemd-journal", unit="restic-backups-system.service"} |= "ERROR"

# Completion status
{job="systemd-journal", unit="restic-backups-system.service"} |= "completed"
```

## Manual Backup Operations

### Trigger Immediate Backup

```bash
systemctl start restic-backups-system.service
```

### Check Repository Status

```bash
# Set environment variables (adjust hostname as needed)
export RESTIC_REPOSITORY=/mnt/backup/$(hostname)/restic
export RESTIC_PASSWORD_FILE=/etc/restic/password

# List all snapshots
restic snapshots

# Show repository statistics
restic stats

# Show storage usage by snapshot
restic stats --mode raw-data

# Show duplicate data savings
restic stats --mode restore-size
```

### Validate Repository Integrity

```bash
# Quick repository check
restic check

# Thorough check (reads 10% of data)
restic check --read-data-subset=10%

# Full data verification (slow, comprehensive)
restic check --read-data
```

## Backup Recovery

### List Files in Snapshots

```bash
# List files in latest snapshot
restic ls latest

# List with details
restic ls latest --long /persist/home

# Find specific files across all snapshots
restic find "*.nix" --snapshot latest

# Search for files by pattern
restic find "important-file"
```

### Restore Files

```bash
# Restore specific file
restic restore latest --target /tmp/restore --include /persist/important-file

# Restore entire directory
restic restore latest --target /tmp/restore --include /persist/home/user

# Restore specific snapshot by ID
restic restore abc123def --target /tmp/restore

# Restore multiple paths
restic restore latest --target /tmp/restore \
  --include /persist/home/user/documents \
  --include /persist/home/user/config
```

### Full System Restore

Complete disaster recovery process:

1. **Boot from NixOS installer** (ISO or network boot)

2. **Set up disk partitioning**:
   ```bash
   # Use disko for declarative partitioning
   nix run github:nix-community/disko -- --mode disko /path/to/disko-config.nix
   ```

3. **Mount restore location**:
   ```bash
   mkdir -p /mnt/restore
   ```

4. **Configure Restic**:
   ```bash
   export RESTIC_REPOSITORY=/mnt/backup/$(hostname)/restic
   export RESTIC_PASSWORD_FILE=/path/to/password
   ```

5. **Restore critical data**:
   ```bash
   # Restore persist directory
   restic restore latest --target /mnt/restore/persist --include /persist

   # Restore home directory (freya)
   restic restore latest --target /mnt/restore/home --include /home

   # Restore service data (thor)
   restic restore latest --target /mnt/restore/srv --include /srv
   ```

6. **Copy restored data**:
   ```bash
   # Adjust paths based on your disk layout
   cp -a /mnt/restore/persist/* /mnt/persist/
   cp -a /mnt/restore/home/* /mnt/home/
   ```

7. **Rebuild system**:
   ```bash
   nixos-rebuild switch --flake /mnt/persist/nilfheim#$(hostname)
   ```

## Repository Management

### Manual Cleanup

Retention policy is automated, but manual cleanup can be triggered:

```bash
restic forget --keep-daily 14 --keep-weekly 8 --keep-monthly 6 --keep-yearly 2 --prune
```

### Repository Maintenance

```bash
# Rebuild index (if corrupted or slow)
restic rebuild-index

# Check and repair repository
restic check --read-data-subset=5%

# Prune unreferenced data
restic prune

# Emergency unlock (if repository is locked)
restic unlock
```

### Browse Snapshot Contents

```bash
# Mount snapshot as filesystem (requires FUSE)
mkdir /tmp/restic-mount
restic mount /tmp/restic-mount

# Browse in another terminal
cd /tmp/restic-mount/snapshots/latest

# Unmount when done
fusermount -u /tmp/restic-mount
```

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Repository locked | Run `restic unlock` |
| Backup service failing | Check logs: `journalctl -u restic-backups-system.service` |
| Out of disk space | Check repository size: `restic stats` and run `restic prune` |
| Slow backups | Check for large files, consider excluding cache directories |
| Permission errors | Verify service user has read access to backup paths |

### Debug Commands

```bash
# Test backup with verbose output
restic backup /path/to/test --verbose

# Check repository integrity with progress
restic check --verbose

# Show backup progress
restic backup /path --verbose --progress

# Dry run restore (test without writing)
restic restore latest --target /tmp/test --dry-run
```

### Performance Optimization

```bash
# Adjust compression level (in service configuration)
# --compression max|auto|off

# Limit upload bandwidth
restic backup /path --limit-upload 1024  # KB/s

# Use pack size optimization for large files
restic backup /path --pack-size 64  # MB
```

## Configuration Reference

Backup service configuration location: `modules/nixos/services/backup/restic.nix`

Key configuration options:
- `paths`: Directories to backup
- `repository`: Local or remote repository path
- `schedule`: Systemd timer schedule (OnCalendar format)
- `retention`: Keep policies for snapshots
- `passwordFile`: Location of encryption password

Example configuration:

```nix
services.backup.restic = {
  enable = true;
  paths = ["/persist" "/srv"];
  repository = "/mnt/backup/thor/restic";
  schedule = "daily";
  retention = {
    keep-daily = 14;
    keep-weekly = 8;
    keep-monthly = 6;
    keep-yearly = 2;
  };
};
```
