# Thor Troubleshooting Guide

Common issues, diagnostic procedures, and resolution steps for the thor homelab server.

## Quick Diagnostics

### System Health Check
```bash
# Check for failed services
systemctl --failed

# Check system load
uptime

# Check disk space
df -h

# Check ZFS pool health
zpool status

# Check memory usage
free -h

# View system logs
journalctl -p err -n 50
```

### Service Health Check
```bash
# Check specific service
systemctl status <service>

# View recent service logs
journalctl -u <service> -n 100

# Check all service statuses (homepage dashboard)
https://homepage.greensroad.uk

# Check metrics (Grafana)
https://grafana.greensroad.uk
```

## Common Issues

### Issue: Service Won't Start

**Symptoms**:
- `systemctl status <service>` shows "failed" or "inactive (dead)"
- Service logs show errors

**Diagnostic Steps**:
```bash
# Check service status
systemctl status <service>

# View detailed logs
journalctl -u <service> -n 200 --no-pager

# Check dependencies
systemctl list-dependencies <service>

# Check if port is already in use
sudo ss -tulpn | grep <port>
```

**Common Causes & Solutions**:

1. **Port Conflict**:
   - Symptom: "Address already in use" or "bind: address already in use"
   - Solution: Check what's using the port: `sudo ss -tulpn | grep <port>`, kill conflicting process or change service port

2. **Missing Dependency**:
   - Symptom: "Failed to start" with dependency error
   - Solution: Start dependency first: `sudo systemctl start <dependency>`

3. **Permission Error**:
   - Symptom: "Permission denied" in logs
   - Solution: Check file ownership: `ls -la /srv/<service>`, fix with `sudo chown -R <user>:<group> /srv/<service>`

4. **Configuration Error**:
   - Symptom: Service-specific config error in logs
   - Solution: Review service configuration in `modules/nixos/services/<category>/<service>.nix`, rebuild: `sudo nixos-rebuild switch --flake .#thor`

### Issue: Service Running But Not Accessible

**Symptoms**:
- Service shows "active (running)" but web interface doesn't load
- Connection timeout or refused

**Diagnostic Steps**:
```bash
# Check if service is listening
sudo ss -tulpn | grep <port>

# Test local connectivity
curl -I http://localhost:<port>

# Check firewall
sudo iptables -L -v -n | grep <port>

# Check nginx proxy (if applicable)
sudo nginx -t
systemctl status nginx
```

**Common Causes & Solutions**:

1. **Nginx Not Proxying**:
   - Solution: Check nginx configuration, reload: `sudo systemctl reload nginx`

2. **Firewall Blocking**:
   - Solution: Verify firewall rules allow port, check service module firewall config

3. **Service Binding to Wrong Interface**:
   - Solution: Verify service binds to `127.0.0.1` (for proxied services) or `0.0.0.0` (for direct access)

4. **Cloudflared Tunnel Down**:
   - Solution: Check tunnel status: `systemctl status cloudflared-tunnel-*`, view logs: `journalctl -u cloudflared-tunnel-* -f`

### Issue: High CPU Usage

**Symptoms**:
- System sluggish
- `htop` shows high CPU usage
- Fans running loudly

**Diagnostic Steps**:
```bash
# Identify top CPU consumers
htop
# or
top

# Check systemd-cgtop for service resource usage
systemd-cgtop

# View CPU metrics in Grafana
https://grafana.greensroad.uk
```

**Common Causes & Solutions**:

1. **Jellyfin Transcoding**:
   - Symptom: `ffmpeg` processes consuming CPU
   - Solution: Normal during video transcoding, ensure clients use compatible formats to avoid transcoding

2. **Tdarr Transcoding**:
   - Symptom: High CPU from Tdarr container
   - Solution: Normal during media processing, adjust Tdarr worker limits if needed

3. **Backup Running**:
   - Symptom: `restic` or compression processes
   - Solution: Normal during backup window, adjust backup schedule if problematic

4. **Service Misbehavior**:
   - Solution: Identify service with `systemd-cgtop`, restart: `sudo systemctl restart <service>`

### Issue: Disk Space Full

**Symptoms**:
- Services failing to write data
- "No space left on device" errors
- Alerts from monitoring

**Diagnostic Steps**:
```bash
# Check disk usage
df -h

# Check ZFS dataset usage
zfs list -o name,used,avail,refer

# Find large directories
du -sh /srv/* | sort -h
du -sh /mnt/* | sort -h

# Check Nix store size
du -sh /nix/store
```

**Common Causes & Solutions**:

1. **Nix Store Bloat**:
   - Solution: Clean up old generations: `sudo nix-collect-garbage --delete-older-than 30d`, then `sudo nixos-rebuild boot --flake .#thor` to create new boot entry

2. **Service Data Growth** (`/srv`):
   - Solution: Identify culprit with `du -sh /srv/*`, clean up logs or old data:
     - Prometheus: Reduce retention or delete old data
     - Loki: Adjust retention policy
     - Grafana: Clean up old dashboards/snapshots

3. **Download Directory Full** (`/mnt/downloads`):
   - Solution: Clean up completed downloads, adjust *arr settings to auto-delete after import

4. **ZFS Snapshots**:
   - Solution: List snapshots: `zfs list -t snapshot`, delete old manual snapshots if needed

5. **Logs** (`/var/log`):
   - Solution: Check log sizes: `du -sh /var/log/*`, configure log rotation or clean up

### Issue: ZFS Pool Degraded

**Symptoms**:
- `zpool status` shows "DEGRADED" state
- Alert from monitoring
- Disk errors in logs

**Diagnostic Steps**:
```bash
# Check pool status
zpool status -v

# Check disk health
sudo smartctl -a /dev/nvme0
sudo smartctl -a /dev/sda

# Review system logs for disk errors
journalctl -p err | grep -i "disk\|ata\|sda\|nvme"
```

**Solutions**:

1. **Transient Error**:
   - Clear errors: `sudo zpool clear <pool>`
   - Monitor for recurrence

2. **Disk Failure**:
   - Replace disk immediately
   - If mirrored: `sudo zpool replace <pool> /dev/old /dev/new`
   - If not mirrored: Restore from backup after replacement

3. **Cable/Controller Issue**:
   - Reseat cables
   - Check controller status

### Issue: Network Connectivity Problems

**Symptoms**:
- Cannot access thor from network
- Services unreachable
- DNS not resolving

**Diagnostic Steps**:
```bash
# Check network interfaces
ip addr show

# Check default route
ip route show

# Test external connectivity
ping 8.8.8.8
ping google.com

# Check DNS
dig @127.0.0.1 -p 4000 google.com

# Check Tailscale status
tailscale status

# Check Cloudflared tunnel
systemctl status cloudflared-tunnel-*
```

**Common Causes & Solutions**:

1. **Tailscale Down**:
   - Solution: Restart Tailscale: `sudo systemctl restart tailscale`, verify: `tailscale status`

2. **Cloudflared Tunnel Down**:
   - Solution: Restart tunnel: `sudo systemctl restart cloudflared-tunnel-*`, check credentials in agenix

3. **DNS (Blocky) Not Working**:
   - Solution: Restart Blocky: `sudo systemctl restart blocky`, check PostgreSQL is running

4. **Network Interface Down**:
   - Solution: Bring up interface: `sudo ip link set eno1 up`, check physical connection

### Issue: Service Database Corruption

**Symptoms**:
- Service fails to start with database error
- "database is locked" or "database corrupt" in logs

**Diagnostic Steps**:
```bash
# Check service logs
journalctl -u <service> -n 100

# Check database file
ls -lh /srv/<service>/*.db

# Check if database process is running
ps aux | grep <service>
```

**Solutions**:

1. **SQLite Lock**:
   - Stop service: `sudo systemctl stop <service>`
   - Remove lock: `rm /srv/<service>/*.db-wal /srv/<service>/*.db-shm`
   - Start service: `sudo systemctl start <service>`

2. **Database Corruption**:
   - Stop service
   - Restore from ZFS snapshot (see [Backup & Recovery](backup-and-recovery.md))
   - Or restore from Restic backup
   - Start service

3. **PostgreSQL Issues** (Blocky, etc.):
   - Check PostgreSQL: `systemctl status postgresql`
   - Check connection: `sudo -u postgres psql -l`
   - Review PostgreSQL logs: `journalctl -u postgresql -n 100`

### Issue: Backup Failing

**Symptoms**:
- `restic-backups-system.service` shows failed
- Backup alerts in monitoring

**Diagnostic Steps**:
```bash
# Check backup service status
systemctl status restic-backups-system.service

# View backup logs
journalctl -u restic-backups-system.service -n 200

# Check backup repository
export RESTIC_REPOSITORY=/mnt/backup/thor/restic
export RESTIC_PASSWORD_FILE=/etc/restic/password
restic check
```

**Common Causes & Solutions**:

1. **Repository Locked**:
   - Symptom: "repository is already locked" in logs
   - Solution: Unlock: `restic unlock`

2. **Insufficient Space**:
   - Symptom: "no space left on device"
   - Solution: Clean up `tank/backup` or expand storage

3. **Permission Error**:
   - Solution: Check `/mnt/backup` permissions: `ls -la /mnt/backup`

4. **Repository Corruption**:
   - Solution: Run `restic check --read-data-subset=10%`, repair if needed

## Service-Specific Troubleshooting

### Jellyfin Issues

**Video Won't Play**:
- Check transcoding logs: `journalctl -u jellyfin | grep transcode`
- Verify media file exists and is readable
- Check ffmpeg is installed and working

**Library Not Scanning**:
- Check NFS mount: `mount | grep media`
- Verify permissions: `ls -la /mnt/media`
- Trigger manual scan in Jellyfin UI

### *arr Services (Sonarr, Radarr, etc.)

**Downloads Not Starting**:
- Check Prowlarr is running and configured
- Verify Transmission is running: `systemctl status transmission`
- Check *arr logs for indexer errors

**Import Failures**:
- Check destination path permissions: `ls -la /mnt/media`
- Verify disk space: `df -h /mnt/media`
- Review *arr logs for specific error

### Prometheus/Grafana Issues

**Metrics Missing**:
- Check exporter is running: `systemctl status prometheus-node-exporter`
- Verify Prometheus is scraping: https://prometheus.greensroad.uk/targets
- Check exporter endpoint: `curl http://localhost:9100/metrics`

**Dashboards Not Loading**:
- Check Grafana logs: `journalctl -u grafana -n 100`
- Verify Prometheus data source: Grafana → Configuration → Data Sources
- Test Prometheus query: https://prometheus.greensroad.uk

## Recovery Procedures

### Emergency Service Restart
```bash
# Restart single service
sudo systemctl restart <service>

# Restart all failed services
systemctl --failed --no-legend | awk '{print $1}' | xargs sudo systemctl restart
```

### Emergency System Reboot
```bash
# Safe reboot (stops services cleanly)
sudo systemctl reboot

# Force reboot (if system unresponsive)
sudo systemctl reboot --force

# Emergency reboot (kernel-level, last resort)
echo b | sudo tee /proc/sysrq-trigger
```

### Roll Back to Previous Configuration
```bash
# List available generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Reboot into previous generation (GRUB menu)
# Or manually:
sudo /nix/var/nix/profiles/system-<number>-link/bin/switch-to-configuration switch
```

### Restore from Backup
See [Backup & Recovery](backup-and-recovery.md) for detailed procedures.

## Performance Troubleshooting

### Slow I/O Performance
```bash
# Check disk I/O
iostat -x 1

# Check ZFS ARC stats
arcstat 1

# Check pool I/O
zpool iostat -v 1

# Identify I/O-heavy processes
iotop
```

### Network Performance Issues
```bash
# Check network throughput
iftop

# Test internal bandwidth
iperf3 -s  # On thor
iperf3 -c thor  # From client

# Check for packet loss
ping -c 100 <host>

# View network errors
ip -s link show eno1
```

## Escalation Paths

### When to Escalate

1. **Critical Service Down >1 hour**
2. **Data Loss Risk** (ZFS pool degraded, backup failing)
3. **Security Incident** (unauthorized access, compromise)
4. **Unknown Issue** (no clear cause after 30min investigation)

### Escalation Checklist
- [ ] Document symptoms and diagnostic steps taken
- [ ] Capture relevant logs: `journalctl -u <service> > /tmp/service.log`
- [ ] Note recent changes (last 24-48 hours)
- [ ] Check monitoring dashboards (Grafana, Homepage)
- [ ] Verify backups are current

### Support Resources
- Documentation: This guide and related docs
- Configuration: GitHub repository
- Monitoring: Grafana dashboards
- Community: NixOS Discourse, Reddit, IRC

## Preventive Maintenance

### Weekly
- Review failed services: `systemctl --failed`
- Check disk space: `df -h`
- Review alerts: Alertmanager

### Monthly
- Run ZFS scrub: `sudo zpool scrub zroot tank`
- Test backup restore
- Update packages: `nix flake update && sudo nixos-rebuild switch --flake .#thor`
- Review logs for patterns

### Quarterly
- Full disaster recovery test
- Review and update documentation
- Audit service configurations
- Plan capacity upgrades

## Related Documentation
- [🏗️ System Architecture](system-architecture.md)
- [🔧 Services Inventory](services/README.md)
- [📊 Monitoring & Alerting](monitoring-and-alerting.md)
- [💾 Backup & Recovery](backup-and-recovery.md)
- [🔙 Back to Thor Overview](README.md)

---

**Need Help?** Check [Monitoring Dashboards](monitoring-and-alerting.md) for real-time system state.
