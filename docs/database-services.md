# Database Services Documentation

## Overview

The Nilfheim configuration includes a comprehensive database infrastructure centered around PostgreSQL with pgAdmin for administration. This provides robust data storage, analytics capabilities, and easy database management for all homelab services.

## 🗄️ Architecture

### Components

- **PostgreSQL 16**: Primary database server with optimized configuration
- **pgAdmin**: Web-based administration interface  
- **Integration Layer**: Seamless service integration with automatic setup
- **Monitoring**: Grafana dashboards for performance and query analysis

### Network Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Applications  │    │   PostgreSQL     │    │     pgAdmin     │
│  (Blocky, etc.) │────│   Database       │────│  Web Interface  │
│                 │    │   Port: 5432     │    │   Port: 5050    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────────────┐
                    │     Tailscale Network   │
                    │    (100.64.0.0/10)     │
                    └─────────────────────────┘
```

## 🚀 PostgreSQL Configuration

### Core Settings

The PostgreSQL service is configured with production-ready settings optimized for homelab workloads:

```nix
services.postgresql = {
  package = pkgs.postgresql_16;
  dataDir = "${constants.paths.dataDir}/postgresql";
  enableTCPIP = true;
  
  settings = {
    # Connection settings
    port = constants.ports.postgresql;  # 5432
    max_connections = 100;
    
    # Memory settings
    shared_buffers = "256MB";
    effective_cache_size = "1GB";
    
    # Performance settings
    random_page_cost = 1.1;
    effective_io_concurrency = 200;
    
    # Logging for monitoring
    log_statement = "all";
    log_min_duration_statement = 1000; # Log slow queries
    
    # WAL settings for reliability
    wal_level = "replica";
    max_wal_size = "1GB";
    min_wal_size = "80MB";
  };
};
```

### Security Configuration

**Authentication Matrix:**
- Local connections: `trust` for system administration
- Application connections: `md5` password authentication
- Network access: Restricted to localhost and Tailscale network
- Replication: Configured for future expansion

**Firewall Rules:**
```nix
# Allow PostgreSQL access over Tailscale network
networking.firewall.interfaces.tailscale0.allowedTCPPorts = [5432];
```

### Data Directory Management

```nix
# Ensure proper permissions for PostgreSQL data
systemd.tmpfiles.rules = [
  "d ${constants.paths.dataDir}/postgresql 0750 postgres postgres -"
];
```

## 🔧 pgAdmin Configuration

### Web Interface Setup

```nix
services.pgadmin = {
  port = constants.ports.pgadmin;  # 5050
  initialEmail = config.user.email;
  initialPasswordFile = pkgs.writeText "pgadmin_password" "password123";
};
```

### Homepage Integration

The pgAdmin interface is automatically integrated into the homepage dashboard:

```nix
services.homepage-dashboard.homelabServices = [{
  group = "Data";
  name = "pgAdmin";
  entry = {
    href = "https://pgadmin.${config.homelab.domain}";
    icon = "postgresql.svg";
    siteMonitor = "http://127.0.0.1:5050";
    description = "PostgreSQL administration interface";
  };
}];
```

### Nginx Proxy Configuration

```nix
services.nginx.virtualHosts."pgadmin.${config.homelab.domain}" = {
  locations."/" = {
    proxyPass = "http://127.0.0.1:5050";
    proxyWebsockets = true;
  };
};
```

## 📊 Service Integration Patterns

### Automatic Database Setup

Services requiring database storage can automatically configure their database needs:

```nix
# Example: Blocky DNS logging configuration
services.postgresql.initialScript = pkgs.writeText "postgresql-init.sql" ''
  CREATE DATABASE ${config.services.blocky.postgres.database};
  CREATE USER ${config.services.blocky.postgres.user} WITH PASSWORD '${config.services.blocky.postgres.password}';
  GRANT ALL PRIVILEGES ON DATABASE ${config.services.blocky.postgres.database} TO ${config.services.blocky.postgres.user};
  \c ${config.services.blocky.postgres.database};
  GRANT ALL ON SCHEMA public TO ${config.services.blocky.postgres.user};
  ALTER USER ${config.services.blocky.postgres.user} CREATEDB;
'';
```

### Database Connection Configuration

Services connect using standardized patterns:

```nix
# Application database configuration
database = {
  host = "127.0.0.1";
  port = constants.ports.postgresql;
  user = "service_user";
  password = "service_password";  # In practice, use secrets
  database = "service_db";
};
```

## 📈 Monitoring & Analytics

### Grafana Dashboards

The database infrastructure includes comprehensive monitoring:

1. **Blocky DNS Analytics Dashboard** (21 panels):
   - Real-time query analysis
   - Response time monitoring
   - Block effectiveness tracking
   - Client behavior analysis
   - Cache performance metrics

2. **Database Performance Dashboard**:
   - Connection monitoring
   - Query performance analysis
   - Resource utilization tracking

### Query Analysis

Key queries for DNS analytics:

```sql
-- Query volume by response type over time
SELECT
  date_trunc('minute', request_ts) as time,
  response_type,
  count(*) as value
FROM log_entries
WHERE request_ts >= NOW() - INTERVAL '1 hour'
GROUP BY date_trunc('minute', request_ts), response_type
ORDER BY time;

-- Top blocked domains
SELECT 
  question_name as domain,
  count(*) as blocked_count
FROM log_entries 
WHERE response_type = 'BLOCKED'
  AND request_ts >= NOW() - INTERVAL '24 hours'
GROUP BY question_name
ORDER BY blocked_count DESC
LIMIT 20;

-- Client activity analysis
SELECT 
  client_ip,
  count(*) as total_queries,
  count(CASE WHEN response_type = 'BLOCKED' THEN 1 END) as blocked_queries,
  ROUND(
    (count(CASE WHEN response_type = 'BLOCKED' THEN 1 END) * 100.0 / count(*)), 2
  ) as block_percentage
FROM log_entries
WHERE request_ts >= NOW() - INTERVAL '24 hours'
GROUP BY client_ip
ORDER BY total_queries DESC;
```

## 🔐 Security Considerations

### Network Security

- **Tailscale Integration**: Database access restricted to secure mesh network
- **Firewall Configuration**: Explicit port allowances per interface
- **Authentication**: Strong password requirements for all database users

### Access Control

```nix
# PostgreSQL authentication configuration
authentication = mkForce ''
  # TYPE  DATABASE        USER            ADDRESS                 METHOD
  local   all             postgres                                peer
  local   all             all                                     trust
  host    all             all             127.0.0.1/32            trust
  host    all             all             ::1/128                 trust
  
  # Application access with password authentication
  host    blocky_logs     blocky          127.0.0.1/32           md5
  host    blocky_logs     blocky          100.64.0.0/10          md5
'';
```

### Data Protection

- **Backup Ready**: Proper directory structure for backup services
- **Permission Model**: Least privilege access for all database users
- **Connection Encryption**: SSL/TLS for network connections (future enhancement)

## 🛠️ Administration Tasks

### Common Operations

**Via pgAdmin Web Interface:**
1. Access https://pgadmin.domain.com
2. Login with configured email/password
3. Connect to PostgreSQL server (localhost:5432)
4. Perform queries, view logs, manage schemas

**Via Command Line:**
```bash
# Connect to PostgreSQL as postgres user
sudo -u postgres psql

# Connect to specific database
sudo -u postgres psql -d blocky_logs

# View active connections
SELECT * FROM pg_stat_activity;

# Monitor query performance
SELECT * FROM pg_stat_statements;
```

### Maintenance

**Database Statistics Update:**
```sql
-- Update table statistics for better query planning
ANALYZE;

-- Full vacuum for space reclamation
VACUUM FULL;

-- Reindex for performance
REINDEX DATABASE blocky_logs;
```

**Log Rotation:**
The PostgreSQL configuration includes automatic log management with retention policies.

## 🚀 Future Enhancements

### Planned Improvements

1. **SSL/TLS Encryption**: Secure connections for all database traffic
2. **Backup Integration**: Automated backups with Restic
3. **Replication**: Master-slave setup for high availability
4. **Connection Pooling**: PgBouncer for improved performance
5. **Monitoring Expansion**: Additional Prometheus exporters
6. **Data Retention**: Automated cleanup policies for log data

### Additional Database Services

Potential future additions to the data services stack:

- **Redis**: In-memory caching for application performance
- **InfluxDB**: Time-series database for metrics storage
- **TimescaleDB**: PostgreSQL extension for time-series workloads

## 📚 Resources

### Documentation Links

- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [pgAdmin Documentation](https://www.pgadmin.org/docs/)
- [NixOS PostgreSQL Configuration](https://nixos.org/manual/nixos/stable/index.html#sec-services-postgresql)

### Configuration Files

- `modules/nixos/services/data/postgresql.nix` - PostgreSQL service configuration  
- `modules/nixos/services/data/pgadmin.nix` - pgAdmin web interface setup
- `lib/constants.nix` - Centralized ports and paths configuration
- `modules/nixos/services/monitoring/grafana/` - Dashboard configurations

### Related Services

- **Blocky DNS**: Primary consumer of PostgreSQL logging
- **Grafana**: Visualization and analytics platform
- **Homepage**: Service discovery and monitoring integration
- **Nginx**: Reverse proxy for web interface access