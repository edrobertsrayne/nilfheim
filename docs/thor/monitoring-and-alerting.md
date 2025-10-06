# Thor Monitoring & Alerting

Comprehensive monitoring and alerting system for thor using Prometheus, Grafana, Loki, and Alertmanager.

## Monitoring Stack Overview

```
┌──────────────────────────────────────────────────────────────┐
│                     Data Sources                             │
├──────────────────────────────────────────────────────────────┤
│  System Metrics    │  Service Metrics  │  Application Logs   │
│  (node-exporter)   │  (exporters)      │  (promtail)         │
│                    │                   │                     │
│  • CPU, Memory     │  • *arr stats     │  • systemd journal  │
│  • Disk I/O        │  • SMART health   │  • nginx logs       │
│  • Network         │  • ZFS metrics    │  • service logs     │
└─────────┬──────────┴─────────┬─────────┴───────────┬─────────┘
          │                    │                     │
          ▼                    ▼                     ▼
    ┌──────────┐         ┌──────────┐        ┌──────────┐
    │Prometheus│         │Prometheus│        │   Loki   │
    │  (9090)  │◄────────┤ Exporters│        │  (3100)  │
    └────┬─────┘         └──────────┘        └────┬─────┘
         │                                         │
         │  ┌──────────────────────────────────┐  │
         └─►│         Grafana (3000)           │◄─┘
            │  Visualization & Dashboards      │
            └──────────────────────────────────┘
         │
         └──────────────────────►┌──────────────┐
                                 │ Alertmanager │
                                 │    (9093)    │
                                 └──────────────┘
```

##Access Points

| Service | URL | Purpose |
|---------|-----|---------|
| Grafana | https://grafana.greensroad.uk | Primary dashboard and visualization |
| Prometheus | https://prometheus.greensroad.uk | Metrics query interface |
| Loki | https://loki.greensroad.uk | Log query interface (or via Grafana) |
| Alertmanager | https://alertmanager.greensroad.uk | Alert management |
| Homepage | https://homepage.greensroad.uk | Service status overview |
| Uptime Kuma | https://uptime-kuma.greensroad.uk | Uptime history |
| Glances | https://glances.greensroad.uk | Real-time system stats |

## Metrics Collection (Prometheus)

### Scrape Configuration

**Scrape Targets** (from [`modules/nixos/services/monitoring/prometheus.nix`](../../modules/nixos/services/monitoring/prometheus.nix)):

| Job | Target | Interval | Purpose |
|-----|--------|----------|---------|
| node | localhost:9100 | 10s | System metrics (CPU, memory, disk, network) |
| promtail | localhost:9080 | 10s | Promtail health metrics |
| alertmanager | localhost:9093 | 10s | Alertmanager status |
| smartctl | localhost:9633 | 60s | Disk health (SMART) |

**Additional Exporters** (configured in service modules):
- ZFS exporter (pool/dataset metrics)
- Exportarr (Sonarr, Radarr, Lidarr, Bazarr, Prowlarr)

### Metrics Retention
- **Default**: 15 days (Prometheus default)
- **Storage**: `/srv/prometheus`

### Query Examples

**System Metrics**:
```promql
# CPU usage by core
rate(node_cpu_seconds_total{mode!="idle"}[5m])

# Memory usage percentage
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Disk usage percentage
(node_filesystem_size_bytes{mountpoint="/"} - node_filesystem_avail_bytes{mountpoint="/"}) / node_filesystem_size_bytes{mountpoint="/"} * 100

# Network throughput
rate(node_network_receive_bytes_total{device="eno1"}[5m])
```

**Service Metrics**:
```promql
# Sonarr queue size
sonarr_queue_total

# Radarr missing movies
radarr_missing_total

# Transmission active torrents
transmission_active_torrent_count
```

**Disk Health**:
```promql
# SMART health status (0 = good, 1 = bad)
smartctl_device_smart_healthy == 0

# Disk temperature
smartctl_device_temperature
```

## Log Aggregation (Loki)

### Log Sources (Promtail)

**Systemd Journal**: All service logs
- Collected via `journald` integration
- Labeled by unit, hostname, syslog_identifier

**Nginx Logs**: Access and error logs
- Access: `/var/log/nginx/access.log`
- Error: `/var/log/nginx/error.log`

**Service-Specific Logs**: Application logs (if configured)

### Log Retention
- **Default**: 30 days (configurable)
- **Storage**: `/srv/loki`

### Query Examples (LogQL)

**Systemd Service Logs**:
```logql
# All logs from Sonarr
{job="systemd-journal", unit="sonarr.service"}

# Errors from any service
{job="systemd-journal"} |= "error"

# Jellyfin transcoding logs
{job="systemd-journal", unit="jellyfin.service"} |= "transcode"
```

**Nginx Logs**:
```logql
# All nginx access logs
{job="nginx-access"}

# Failed requests (4xx, 5xx)
{job="nginx-access"} | regexp `HTTP/[0-9.]+ [45][0-9]{2}`

# Nginx errors
{job="nginx-error"} |= "error"
```

**Backup Logs**:
```logql
# Restic backup service logs
{job="systemd-journal", unit="restic-backups-system.service"}

# Backup errors
{job="systemd-journal", unit="restic-backups-system.service"} |= "ERROR"

# Backup completion
{job="systemd-journal", unit="restic-backups-system.service"} |= "completed"
```

## Grafana Dashboards

### Pre-configured Dashboards

1. **System Overview**: CPU, memory, disk, network, uptime
2. **ZFS Dashboard**: Pool health, dataset usage, ARC stats
3. **Blocky DNS Analytics**: Queries, blocking stats, client analysis (21 panels)
4. **Service Health**: *arr services, download clients, media servers
5. **Nginx Analytics**: Request rate, response times, status codes
6. **Disk Health**: SMART metrics, temperature, errors

**Access**: https://grafana.greensroad.uk

### Data Sources
- **Prometheus**: Metrics (default data source)
- **Loki**: Logs (explore interface)

### Creating Custom Dashboards
1. Navigate to Grafana → Dashboards → New Dashboard
2. Add panels with PromQL or LogQL queries
3. Configure visualization (graph, gauge, table, etc.)
4. Set thresholds and alerts
5. Save dashboard

## Alerting (Alertmanager)

### Alert Rules

**Location**: `modules/nixos/services/monitoring/prometheus.nix` (ruleFiles)

**Alert Files**:
- `./alerts/logging.yml` - Log-based alerts
- `./alerts/health-checks.yml` - Service health alerts

### Common Alerts (Examples)

**System Alerts**:
- High CPU usage (>80% for 5min)
- High memory usage (>90% for 5min)
- Low disk space (<10% available)
- High disk I/O wait

**Service Alerts**:
- Service down/failed
- Backup failure
- ZFS pool errors
- SMART disk warnings

**Application Alerts**:
- *arr download stalls
- Jellyfin transcoding failures
- High nginx error rate

### Alert Routing
- **Notification Channels**: Email, Slack, Discord, etc. (configure in Alertmanager)
- **Severity Levels**: info, warning, critical
- **Grouping**: By alert name, service, severity

**Configuration**: [`modules/nixos/services/monitoring/alertmanager.nix`](../../modules/nixos/services/monitoring/alertmanager.nix)

### Silencing Alerts
1. Navigate to Alertmanager: https://alertmanager.greensroad.uk
2. Find active alert
3. Click "Silence"
4. Set duration and reason
5. Confirm

## Uptime Monitoring (Uptime Kuma)

**Purpose**: HTTP/HTTPS endpoint monitoring with status page

**Monitored Services**: All web-accessible services (Jellyfin, Sonarr, Grafana, etc.)

**Features**:
- HTTP status checks
- Response time tracking
- Historical uptime statistics
- Incident timeline
- Status page for external visibility

**Access**: https://uptime-kuma.greensroad.uk

**Configuration**: UI-based (persistent in `/srv/uptime-kuma`)

## Real-time Monitoring (Glances)

**Purpose**: Real-time system resource monitoring

**Metrics**:
- CPU per-core usage
- Memory/swap usage
- Disk I/O
- Network I/O
- Process list (top processes)
- Filesystem usage

**Access**: https://glances.greensroad.uk

**Refresh Rate**: 2 seconds (configurable)

## Service Health Dashboard (Homepage)

**Purpose**: Centralized service dashboard with status indicators

**Features**:
- Service categorization (Media, Downloads, Monitoring, Utilities, Network)
- Health checks (site monitor)
- Quick links to all services
- Service descriptions

**Access**: https://homepage.greensroad.uk

**Configuration**: Declarative via service modules (`homelabServices` option)

## Monitoring Checklist

### Daily Checks
- [ ] Review Homepage dashboard for service status
- [ ] Check Uptime Kuma for any downtime incidents
- [ ] Review Alertmanager for active alerts

### Weekly Checks
- [ ] Review Grafana dashboards (system, ZFS, services)
- [ ] Check Prometheus targets (ensure all scrapers active)
- [ ] Review Loki logs for errors or warnings
- [ ] Check disk space (`df -h`, `/srv` usage)

### Monthly Checks
- [ ] Review alert rules (tune thresholds)
- [ ] Check log retention (Loki disk usage)
- [ ] Review metric retention (Prometheus disk usage)
- [ ] Audit dashboard accuracy
- [ ] Test alerting channels

## Troubleshooting Monitoring Issues

### Prometheus Not Scraping
```bash
# Check Prometheus status
systemctl status prometheus

# View Prometheus logs
journalctl -u prometheus -f

# Check scrape targets (in Prometheus UI)
https://prometheus.greensroad.uk/targets

# Verify exporter is running
systemctl status prometheus-node-exporter
curl http://localhost:9100/metrics
```

### Loki Missing Logs
```bash
# Check Promtail status
systemctl status promtail

# View Promtail logs
journalctl -u promtail -f

# Verify Promtail is shipping logs
curl http://localhost:9080/metrics | grep promtail_sent

# Check Loki ingestion
curl http://localhost:3100/metrics | grep loki_ingester
```

### Grafana Dashboards Not Loading
```bash
# Check Grafana status
systemctl status grafana

# View Grafana logs
journalctl -u grafana -f

# Verify data source connectivity (Grafana UI)
https://grafana.greensroad.uk/datasources

# Test Prometheus query
curl "http://localhost:9090/api/v1/query?query=up"
```

### Alerts Not Firing
```bash
# Check Alertmanager status
systemctl status alertmanager

# View active alerts (Prometheus UI)
https://prometheus.greensroad.uk/alerts

# Check Alertmanager config
sudo cat /etc/alertmanager/alertmanager.yml

# Test alert rule
promtool check rules /path/to/alerts/*.yml
```

## Related Documentation
- [🔧 Services Inventory](services/README.md) - All monitored services
- [💾 Backup & Recovery](backup-and-recovery.md) - Backup monitoring
- [🔙 Back to Thor Overview](README.md)

---

**Configuration Sources**:
- [`modules/nixos/services/monitoring/`](../../modules/nixos/services/monitoring/)
- Grafana provisioning: Auto-configured via NixOS modules
