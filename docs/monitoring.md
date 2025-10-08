# Monitoring and Logging

Complete guide for monitoring infrastructure, querying logs, and troubleshooting issues in Nilfheim.

## Overview

Nilfheim uses a comprehensive monitoring stack:

- **Grafana**: Visualization and dashboards
- **Prometheus**: Metrics collection and storage
- **Loki**: Log aggregation
- **Promtail**: Log shipping
- **AlertManager**: Alert routing and notifications
- **cAdvisor**: Container metrics
- **PostgreSQL**: DNS analytics database

## Grafana Dashboards

Access Grafana at `https://grafana.${domain}`

### Available Dashboards

1. **Homelab Overview** (`/d/homelab-overview`)
   - Single-screen infrastructure view
   - 23 panels covering system health, services, resources

2. **DNS Analytics** (`/d/dns-analytics`)
   - Blocky query analysis
   - 21 panels with real-time monitoring
   - Response types, performance, security analytics

3. **Restic Backup Monitoring** (`/d/restic-backup`)
   - Backup completion status
   - Duration and timing metrics
   - Repository size tracking

4. **Docker Monitoring** (`/d/docker-cadvisor`)
   - Container resource usage
   - CPU, memory, network metrics
   - Per-container statistics

5. **ZFS Monitoring**
   - Pool health and capacity
   - Dataset statistics
   - Snapshot status

6. **System Health**
   - CPU, memory, disk usage
   - Network statistics
   - Service status

See [docs/monitoring-dashboards.md](monitoring-dashboards.md) for detailed dashboard documentation.

## Loki Log Queries

### Service Logs

#### Backup Monitoring

```bash
# All backup logs
{job="systemd-journal", unit="restic-backups-system.service"}

# Backup errors
{job="systemd-journal", unit="restic-backups-system.service"} |= "ERROR"

# Backup completion
{job="systemd-journal", unit="restic-backups-system.service"} |= "completed"

# Backup failures
{job="systemd-journal", unit="restic-backups-system.service"} |= "failed"
```

#### Docker Container Logs

```bash
# Home Assistant logs
{job="docker", container="homeassistant"}

# Portainer logs
{job="docker", container="portainer"}

# Tdarr logs
{job="docker", container="tdarr"}

# All container errors
{job="docker"} |= "ERROR"
```

#### System Services

```bash
# All systemd errors
{job="systemd-journal"} |= "ERROR"

# Failed services
{job="systemd-journal"} |= "failed"

# SSH service logs
{job="systemd-journal", unit="sshd.service"}

# Authentication events
{job="systemd-journal"} |= "authentication"
```

#### Application Logs

```bash
# *arr services errors
{job="arr-services", level="Error"}

# Jellyfin errors
{job="jellyfin"} |= "ERROR"

# Nginx error logs
{job="nginx-error"}

# Nginx access logs (4xx errors)
{job="nginx-access"} | json | status_class="4xx"

# POST requests
{job="nginx-access"} | json | method="POST"
```

### Advanced Query Patterns

#### Time-based Filtering

```bash
# Last hour
{job="systemd-journal"} |= "ERROR" | __timestamp__ > now() - 1h

# Specific time range (use Grafana time picker)
{job="systemd-journal", unit="nginx.service"}
```

#### Multiple Conditions

```bash
# Errors OR warnings
{job="systemd-journal"} |~ "ERROR|WARN"

# Specific service, exclude info messages
{job="systemd-journal", unit="sshd.service"} != "info"

# Multiple services
{job="systemd-journal", unit=~"nginx.service|sshd.service"}
```

#### JSON Parsing

```bash
# Parse nginx access logs
{job="nginx-access"} | json

# Filter by status code
{job="nginx-access"} | json | status="404"

# Filter by status class
{job="nginx-access"} | json | status_class="5xx"
```

#### Rate and Aggregation

```bash
# Error rate per minute
rate({job="systemd-journal"} |= "ERROR" [1m])

# Count errors by service
sum by (unit) (count_over_time({job="systemd-journal"} |= "ERROR" [5m]))
```

## Prometheus Metrics

Access Prometheus at `https://prometheus.${domain}`

### Key Metrics

#### System Metrics (Node Exporter)

```promql
# CPU usage
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))

# Disk usage
100 - ((node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100)

# Network traffic
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])
```

#### Service Metrics (*arr Exporters)

```promql
# Sonarr queue size
sonarr_queue_total

# Radarr missing movies
radarr_movie_missing_total

# Download speed
transmission_session_stats_download_speed_bytes

# Active downloads
transmission_torrent_active_total
```

#### Container Metrics (cAdvisor)

```promql
# Container CPU usage
rate(container_cpu_usage_seconds_total{name!=""}[5m])

# Container memory usage
container_memory_usage_bytes{name!=""}

# Container network I/O
rate(container_network_receive_bytes_total{name!=""}[5m])
rate(container_network_transmit_bytes_total{name!=""}[5m])
```

#### Custom Metrics

```promql
# Backup success/failure
restic_backup_success

# ZFS pool health
zfs_pool_health

# Service uptime
up{job="servicename"}
```

## System Health Monitoring

### Check Service Status

```bash
# Loki status
systemctl status loki.service
curl -s localhost:3100/ready

# Promtail status
systemctl status promtail.service

# Prometheus status
systemctl status prometheus.service
curl -s localhost:9090/-/healthy

# Grafana status
systemctl status grafana.service
```

### Check Metrics and Limits

```bash
# Loki stream count and limits
curl -s localhost:3100/metrics | grep -E "stream|ingester"

# List active jobs
curl -s localhost:3100/loki/api/v1/label/job/values

# Query Prometheus targets
curl -s localhost:9090/api/v1/targets

# Check Prometheus alerts
curl -s localhost:9090/api/v1/alerts
```

### Log Collection Status

```bash
# Check Promtail configuration
journalctl -u promtail.service | grep -E "(error|warn)"

# Verify log file access
ls -la /var/log/nginx/
ls -la /srv/*/logs/

# Test Loki connectivity
curl -G localhost:3100/ready
curl -G localhost:3100/loki/api/v1/labels
```

## Active Log Sources

### SystemD Journal
- Core system services
- Backup monitoring (restic)
- SSH and authentication
- Service failures and errors

### Docker Containers
- Home Assistant
- Tdarr
- Portainer
- Other containerized services

### Application Logs
- *arr services (Sonarr, Radarr, Lidarr, Bazarr, Prowlarr)
- Jellyfin
- Transmission

### Web Server Logs
- Nginx error logs
- Nginx access logs (optimized with reduced cardinality)

### Monitoring Metrics
- **Stream Count**: ~27 active streams (optimized, under 100k limit)
- **Ingestion Rate**: ~5MB/hr average
- **Retention**: 31 days (744 hours)

## Database Analytics

### PostgreSQL DNS Logging

Access pgAdmin at `https://pgadmin.${domain}`

#### Common Queries

```sql
-- Top queried domains (last 24 hours)
SELECT domain, COUNT(*) as query_count
FROM dns_queries
WHERE timestamp > NOW() - INTERVAL '24 hours'
GROUP BY domain
ORDER BY query_count DESC
LIMIT 20;

-- Blocked queries by client
SELECT client_ip, COUNT(*) as blocked_count
FROM dns_queries
WHERE response_type = 'BLOCKED'
GROUP BY client_ip
ORDER BY blocked_count DESC;

-- Query distribution by response type
SELECT response_type, COUNT(*) as count
FROM dns_queries
WHERE timestamp > NOW() - INTERVAL '1 day'
GROUP BY response_type;

-- Response time percentiles
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_ms) as p50,
  PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY duration_ms) as p95,
  PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY duration_ms) as p99
FROM dns_queries
WHERE timestamp > NOW() - INTERVAL '1 hour';
```

## Alerting

### AlertManager Configuration

Access AlertManager at `https://alertmanager.${domain}`

#### View Active Alerts

```bash
# Via web interface
https://alertmanager.${domain}

# Via API
curl -s localhost:9093/api/v2/alerts | jq

# Via Prometheus
curl -s localhost:9090/api/v1/alerts | jq
```

#### Common Alert Rules

- **Service Down**: When service becomes unavailable
- **High CPU Usage**: CPU > 80% for 5 minutes
- **High Memory Usage**: Memory > 90% for 5 minutes
- **Disk Space Low**: Free space < 10%
- **Backup Failed**: Backup job failed or hasn't run in 25 hours
- **High Error Rate**: Error log rate exceeds threshold

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Stream limit exceeded | Reduce label cardinality, optimize queries |
| Timestamp errors | Disable timestamp parsing, use ingestion time |
| No backup logs | Verify systemd journal collection |
| High memory usage | Adjust retention period, stream limits |
| Missing application logs | Check file permissions, service user groups |
| Gaps in metrics | Check scrape_interval and target health |

### Debug Commands

```bash
# Test Loki query
curl -G localhost:3100/loki/api/v1/query \
  --data-urlencode 'query={job="systemd-journal"} |= "ERROR"' \
  --data-urlencode 'limit=10'

# Check Promtail positions
cat /var/lib/promtail/positions.yaml

# Validate Prometheus config
promtool check config /etc/prometheus/prometheus.yml

# Test alerting rules
promtool check rules /etc/prometheus/alerts/*.yml
```

### Performance Optimization

```bash
# Loki query optimization
- Use label filters first: {job="..."} before line filters
- Limit time ranges to reduce query load
- Avoid regex when possible, use literal matches

# Prometheus optimization
- Reduce scrape_interval for less critical services
- Increase retention only for necessary metrics
- Use recording rules for expensive queries

# Stream limit management
- Consolidate similar labels
- Use static labels in scrape configs
- Remove unnecessary label dimensions
```

## Configuration Reference

### Monitoring Stack Locations

- **Grafana**: `modules/nixos/services/monitoring/grafana.nix`
- **Prometheus**: `modules/nixos/services/monitoring/prometheus.nix`
- **Loki**: `modules/nixos/services/monitoring/loki.nix`
- **Promtail**: `modules/nixos/services/monitoring/promtail.nix`
- **AlertManager**: `modules/nixos/services/monitoring/alertmanager.nix`

### Dashboard Locations

- **Dashboard JSON**: `modules/nixos/services/monitoring/grafana/*.json`
- **Provisioning**: Automatic via Grafana provisioning

### Port Assignments

See `lib/constants.nix` for all monitoring service ports:
- Grafana: 3000
- Prometheus: 9090
- Loki: 3100
- Promtail: 9080
- AlertManager: 9093
- Node Exporter: 9100
- cAdvisor: 9800
