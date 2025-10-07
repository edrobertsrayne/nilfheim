# Monitoring Dashboards Documentation

## Overview

The Nilfheim monitoring stack includes comprehensive Grafana dashboards for system health, service monitoring, and advanced analytics. This provides complete visibility into infrastructure performance, security metrics, and operational insights.

## 📊 Dashboard Architecture

### Dashboard Categories

1. **Homelab Overview**: Unified single-screen view of entire infrastructure (16 panels)
2. **DNS Analytics**: Advanced Blocky DNS monitoring with 21 comprehensive panels
3. **Service Monitoring**: Application logs, performance metrics, and health checks
4. **Network Monitoring**: Nginx access logs, request patterns, and security events
5. **Infrastructure**: Promtail log processing, database performance, and resource utilization

## 🏠 Homelab Overview Dashboard

**File**: `modules/nixos/services/monitoring/grafana/homelab-overview.json`
**Panels**: 16 comprehensive overview panels
**Refresh**: 30 seconds
**Purpose**: Single-screen at-a-glance view of entire homelab infrastructure

### Dashboard Sections

#### 1. Critical Status (Row 1 - 2 panels)
- **System Uptime** - Time since last boot with color coding
- **Active Alerts** - Count of firing alerts from AlertManager

#### 2. Resource Overview (Row 2 - 4 panels)
- **CPU Usage** - Percentage gauge with thresholds
- **Memory Usage** - Available vs used memory gauge
- **Network I/O** - TX/RX rates over time
- **System Load** - 1m, 5m, 15m load averages

#### 3. Storage Health (Row 3 - 3 panels)
- **ZFS Pool Health** - ONLINE/DEGRADED/FAULTED status for all pools
- **ZFS Pool Capacity** - Usage percentage bar gauges
- **Critical Mount Points** - /srv, /var/lib, /mnt/media, /mnt/downloads usage

#### 4. Container Metrics (Row 4 - 3 panels)
- **Running Containers** - Total container count with trend
- **Container CPU Usage** - Top 3 containers by CPU
- **Container Memory Usage** - Top 3 containers by memory

#### 5. Network & DNS (Row 5 - 3 panels)
- **DNS Query Rate** - Queries per second from PostgreSQL logs
- **DNS Block Rate** - Percentage of blocked queries
- **Nginx Request Rate** - HTTP requests by method with stacking

#### 6. Application Services (Row 6 - 4 panels)
- **Media Services Status** - Jellyfin, Sonarr, Radarr, Lidarr, Prowlarr health
- **Active Downloads** - Transmission active torrent count
- **Last Successful Backup** - Timestamp of last completed Restic backup
- (Reserved for future expansion)

#### 7. Observability Health (Row 7 - 4 panels)
- **Loki Active Streams** - Current stream count (target <100k)
- **Loki Ingestion Rate** - Logs per second ingestion
- **SMART Disk Health** - Per-disk SMART status
- **Database Connections** - PostgreSQL active connections to blocky_logs

### Conditional Panel Behavior

The dashboard gracefully handles missing services:

**Metrics-based panels** (automatic):
- If a metric doesn't exist, the panel shows "No data"
- Queries use conditional expressions where possible (e.g., `OR vector(0)`)

**Service-specific panels** (conditional on service enablement):
- **ZFS panels** - Require ZFS exporter to be enabled
- **Container panels** - Require Docker and cAdvisor to be enabled
- **DNS panels** - Require Blocky with PostgreSQL integration
- **Backup panel** - Require Restic backup service
- **Database panel** - Require PostgreSQL service

### Data Sources Used

- **Prometheus** - System metrics, service health, container metrics
- **Loki** - Backup completion logs, application logs
- **PostgreSQL** - Blocky DNS query logs (when enabled)

### Key Metrics Displayed

**Infrastructure:**
- System uptime, CPU/memory/network utilization
- ZFS pool health and capacity
- Disk SMART status
- Critical mount point usage

**Services:**
- Service up/down status (nginx, prometheus, grafana, loki, media services)
- Active alert count
- Container resource usage

**Applications:**
- DNS query rate and block effectiveness
- Nginx request rate by method
- Active downloads
- Backup status

**Observability:**
- Loki stream count and ingestion rate
- Database connection count
- Log collection health

## 🔍 Blocky DNS Analytics Dashboard

**File**: `modules/nixos/services/monitoring/grafana/blocky-analytics.json`  
**Panels**: 21 comprehensive analytics panels  
**Data Source**: PostgreSQL (blocky_logs database)

### Key Analytics Panels

#### 📈 Real-time Query Analysis
- **DNS Queries Over Time**: Live query patterns with response type breakdown
- **Response Type Distribution**: Pie chart showing BLOCKED/RESOLVED/CACHED ratios
- **Query Performance**: Response time analysis with percentile tracking

#### 🛡️ Security Insights
- **Block Effectiveness**: Real-time block rate percentage with trend analysis
- **Top Blocked Domains**: Most frequently blocked domains with threat intelligence
- **Suspicious Activity**: Client behavior analysis with anomaly detection
- **Security Heatmap**: Time-based visualization of blocking patterns

#### 👥 Client Intelligence
- **Client Activity**: Top clients by query volume with behavior analysis
- **Geographic Patterns**: Query origin analysis and client distribution
- **Device Fingerprinting**: Query type patterns by client identification
- **Usage Trends**: Historical client activity with growth tracking

#### ⚡ Performance Metrics
- **Cache Efficiency**: Hit rate analysis with performance optimization insights
- **Response Times**: Latency tracking with percentile breakdowns
- **Query Distribution**: Request type analysis (A, AAAA, CNAME, etc.)
- **Error Monitoring**: Failed queries and resolution issues

#### 📊 Statistical Analysis
- **Query Volume Stats**: Total queries, unique clients, error rates
- **Temporal Patterns**: Time-of-day analysis with usage peaks
- **Network Health**: DNS resolution success rates and failure patterns
- **Capacity Planning**: Growth trends and resource utilization

### Example Queries

```sql
-- Real-time DNS query rate by response type
SELECT
  date_trunc('minute', request_ts) as time,
  response_type,
  count(*) as value
FROM log_entries
WHERE $__timeFilter(request_ts)
GROUP BY date_trunc('minute', request_ts), response_type
ORDER BY time;

-- Block effectiveness calculation
SELECT 
  ROUND(
    (COUNT(CASE WHEN response_type = 'BLOCKED' THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as value
FROM log_entries 
WHERE $__timeFilter(request_ts);

-- Top clients with suspicious activity
SELECT 
  client_ip as "Client IP",
  count(*) as "Total Queries",
  count(CASE WHEN response_type = 'BLOCKED' THEN 1 END) as "Blocked",
  ROUND(AVG(duration_ms), 2) as "Avg Response Time (ms)"
FROM log_entries 
WHERE $__timeFilter(request_ts)
GROUP BY client_ip
HAVING count(*) > 100
ORDER BY "Blocked" DESC
LIMIT 20;
```

## 📋 Service Logs Dashboard

**File**: `modules/nixos/services/monitoring/grafana/service-logs.json`  
**Purpose**: Centralized log analysis with intelligent filtering

### Log Analysis Features

#### 🎬 Media Services Monitoring
- ***arr Services Activity**: Sonarr, Radarr, Lidarr, Readarr, Prowlarr log analysis
- **Error Pattern Detection**: Automated issue identification with severity classification
- **Performance Insights**: Processing times and resource utilization
- **Integration Health**: API connectivity and external service monitoring

#### 📺 Streaming Services
- **Jellyfin Analytics**: User activity, transcoding performance, library health  
- **Jellyseerr Requests**: User requests and fulfillment tracking
- **Kavita Reading**: E-book access patterns and library usage

#### 🐳 Container Monitoring
- **Docker Containers**: Home Assistant, Tdarr, and Portainer container monitoring
- **cAdvisor Integration**: Real-time CPU, memory, and network usage metrics
- **Container Lifecycle**: Resource consumption and performance analysis
- **Grafana Dashboard**: `docker-cadvisor.json` with 4 key panels
  - CPU Usage by Container
  - Memory Usage by Container
  - Network I/O (RX/TX rates)
  - Running Container Count
- **Service Dependencies**: Inter-service communication and dependency health
- **Performance Bottlenecks**: Resource constraints and optimization opportunities
- **Log Collection**: Docker socket scraping via Promtail for centralized logs

### Advanced Filtering

```logql
# Media services error detection
{job="systemd-journal", unit=~"(sonarr|radarr|lidarr).service", level="error"}

# Docker container monitoring (via Docker socket)
{job="docker", container="homeassistant"}
{job="docker", container="portainer"}
{job="docker", container="tdarr"}

# Jellyfin transcoding analysis
{job="systemd-journal", unit="jellyfin.service"} | json | message=~".*transcode.*"
```

## 🌐 Nginx Access Logs Dashboard

**File**: `modules/nixos/services/monitoring/grafana/nginx-logs.json`  
**Focus**: Web traffic analysis and security monitoring

### Traffic Intelligence

#### 📊 Request Analytics
- **Request Rate**: Real-time traffic volume with trend analysis
- **Response Analysis**: Status code distribution with error classification
- **Path Intelligence**: Most requested endpoints with usage patterns
- **Method Distribution**: HTTP method analysis (GET, POST, etc.)

#### 🛡️ Security Monitoring
- **Attack Detection**: Suspicious request patterns and threat identification
- **Error Rate Tracking**: 4xx/5xx responses with failure analysis
- **Geographic Intelligence**: Request origin analysis with threat mapping
- **Bot Detection**: Automated traffic identification and filtering

#### ⚡ Performance Insights
- **Response Time Analysis**: Latency tracking with optimization opportunities
- **Bandwidth Utilization**: Data transfer patterns and capacity planning
- **Cache Effectiveness**: Static asset performance and CDN efficiency
- **User Experience**: Page load times and interaction patterns

### Recent Improvements

- ✅ **Cardinality Optimization**: Reduced nginx access log streams from ~50k to 27 streams
- ✅ **Label Reduction**: Simplified to `method` and `status_class` labels only
- ✅ **Status Grouping**: Group status codes into classes (2xx, 3xx, 4xx, 5xx, other)
- ✅ **Full Data Preservation**: All log details preserved as queryable fields
- ✅ **Series Limit Resolution**: Fixed "maximum of series (500) reached" errors
- ✅ **Query Optimization**: Simplified LogQL queries for better performance
- ✅ **Parse Error Fixes**: Resolved regex escaping and JSON pipeline issues
- ✅ **Visualization Corrections**: Fixed time conversion errors for proper display

## 📈 Promtail Monitoring Dashboard

**File**: `modules/nixos/services/monitoring/grafana/promtail-monitoring.json`  
**Purpose**: Log pipeline performance and reliability monitoring

### Pipeline Health Monitoring

#### 📤 Log Processing Metrics
- **Log Ingestion Rate**: Lines per second processed with throughput analysis
- **Processing Efficiency**: Bytes processed and transfer rates
- **Queue Performance**: Buffer utilization and backlog monitoring
- **Error Detection**: Processing failures and retry patterns

#### 🔧 Operational Intelligence
- **File Monitoring**: Active log files and rotation handling
- **Resource Usage**: Memory and CPU consumption by log processing
- **Network Performance**: Loki connection health and transfer efficiency  
- **Reliability Metrics**: Uptime and processing consistency

## 🎯 Dashboard Standards

### Design Principles

1. **Consistent Theming**: Dark theme with Catppuccin color scheme
2. **Information Density**: Maximum insight per screen real estate
3. **Responsive Design**: Optimal viewing across different screen sizes
4. **Performance Optimized**: Efficient queries with minimal resource impact

### Configuration Standards

```json
{
  "refresh": "30s",
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "style": "dark",
  "tags": ["monitoring", "analytics", "security"],
  "timezone": "browser"
}
```

### Query Optimization

- **Time Range Variables**: Use `$__timeFilter()` for dynamic filtering
- **Aggregation**: Prefer server-side aggregation over client-side processing
- **Indexing**: Leverage database indexes for optimal query performance
- **Caching**: Implement query result caching for frequently accessed data

## 🔧 Dashboard Maintenance

### Regular Tasks

1. **Performance Review**: Monthly analysis of dashboard load times
2. **Data Retention**: Quarterly cleanup of historical dashboard data
3. **Query Optimization**: Ongoing improvement of dashboard query efficiency
4. **User Feedback**: Regular collection and implementation of user suggestions

### Update Procedures

```bash
# Validate dashboard JSON before deployment
jq . dashboard.json > /dev/null

# Test query performance
psql -d blocky_logs -c "EXPLAIN ANALYZE SELECT ..."

# Deploy dashboard update
just thor  # Deploy to homelab server

# Verify dashboard functionality
curl -s "https://grafana.domain.com/api/dashboards/uid/dashboard-uid"
```

## 📚 Dashboard Development

### Creating New Dashboards

1. **Planning Phase**: Define metrics, data sources, and user requirements
2. **Prototype Development**: Create initial panels with basic queries
3. **Query Optimization**: Refine queries for performance and accuracy
4. **Visual Design**: Apply consistent theming and layout principles
5. **Testing**: Validate functionality across different time ranges
6. **Documentation**: Update configuration files and user guides

### Best Practices

- **Single Responsibility**: Each dashboard focuses on specific domain
- **Progressive Disclosure**: Layer information from overview to detail
- **Actionable Insights**: Provide context and next steps for metrics
- **Mobile Friendly**: Ensure readability on smaller screens
- **Performance First**: Optimize for fast loading and minimal resource usage

## 🚀 Future Enhancements

### Planned Improvements

1. **AI-Powered Anomaly Detection**: Machine learning integration for pattern recognition
2. **Automated Alerting**: Threshold-based notifications with escalation procedures  
3. **Cross-Dashboard Navigation**: Unified linking between related dashboards
4. **Export Capabilities**: PDF/PNG generation for reporting purposes
5. **Custom Annotations**: Event marking and collaborative dashboard notes

### Integration Opportunities

- **Alert Manager**: Dashboard-driven alert configuration
- **Homepage Integration**: Dashboard embedding and quick access
- **Mobile Apps**: Native mobile dashboard viewing
- **API Integration**: Programmatic dashboard management and updates

## 📖 Resources

### Configuration Files

- Dashboard JSON files in `modules/nixos/services/monitoring/grafana/`
- Grafana service configuration in `modules/nixos/services/monitoring/grafana.nix`
- Data source configurations in provisioning files

### External Resources

- [Grafana Dashboard Best Practices](https://grafana.com/docs/grafana/latest/dashboards/)
- [LogQL Documentation](https://grafana.com/docs/loki/latest/logql/)
- [PostgreSQL Performance Monitoring](https://www.postgresql.org/docs/current/monitoring-stats.html)
- [Prometheus Query Language](https://prometheus.io/docs/prometheus/latest/querying/)