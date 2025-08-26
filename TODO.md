# Nilfheim Configuration Improvements TODO

## 🚨 Critical Security Issues (IMMEDIATE)

- [X] Fix Plex TLS settings - remove TLS 1.0/1.1 (`modules/nixos/services/media/plex.nix:51-54`)
- [X] Add global nginx security headers (`modules/nixos/services/network/nginx.nix`)
- [X] Restrict service exposure - review `openFirewall = true` settings
- [X] Fix Grafana XSS vulnerability (`modules/nixos/services/monitoring/grafana.nix:127`)
- [X] Enhance SSH hardening with MaxAuthTries, ClientAliveInterval

## ⚠️ High Priority Infrastructure

- [X] Add nginx proxyWebSockets to all exposed services
- [X] Add NFS server/client for shared storage over tailscale network
- [ ] Create Restic backup service (`modules/nixos/services/utilities/restic.nix`)
- [X] Enable ZFS auto-snapshots with retention policies
- [ ] Add backup monitoring with Prometheus integration
- [X] Implement Loki + Promtail for log management
- [X] Add SMART monitoring for disk health
- [X] Create system health checks for ZFS and services
- [X] Configure Blocky query logging to PostgreSQL database  
- [X] Create Grafana dashboard for DNS query monitoring and analytics
- [X] Add PostgreSQL database service with optimized configuration
- [X] Add pgAdmin web interface for database administration
- [X] Create comprehensive Blocky analytics dashboard with 21 panels

## 🔧 Code Refactoring

- [X] Create `lib/services.nix` for service abstraction
- [X] Create `lib/constants.nix` for centralized configuration
- [X] Create `lib/nginx.nix` for proxy helpers
- [X] ~~Create `lib/secrets.nix` for secret management~~ (removed - agenix handles secrets directly)
- [X] Refactor *arr services to eliminate duplication
- [X] Standardize service configuration patterns
- [X] Centralize port assignments
- [X] Create service category modules (implemented selectively - only mkArrService abstraction provides value)
- [X] Eliminate mount point path duplication using centralized constants
- [X] Consolidate ZFS snapshot retention settings

## 🛡️ Enhanced Security

- [X] Implement fail2ban for intrusion prevention
- [X] Enhance Samba security restrictions (completed - restricted to tailscale network)
- [X] Fix sudo passwordless configuration security issue
- [X] Review Tailscale security settings (completed - current configuration is secure)

## 📊 Service Additions

### Database & Analytics Services  
- [X] Add PostgreSQL database service (`modules/nixos/services/data/postgresql.nix`)
- [X] Add pgAdmin web interface (`modules/nixos/services/data/pgadmin.nix`)
- [ ] Add Redis for caching (`modules/nixos/services/data/redis.nix`)
- [ ] Add InfluxDB for time-series data (`modules/nixos/services/data/influxdb.nix`)

### Media & Content Management
- [ ] Add Navidrome for music streaming (`modules/nixos/services/media/navidrome.nix`)
- [ ] Add Deemix for music downloading (`modules/nixos/services/downloads/deemix.nix`)
- [ ] Add Immich for photo management (`modules/nixos/services/media/immich.nix`)

### Productivity Services
- [ ] Add Nextcloud for file sync (`modules/nixos/services/utilities/nextcloud.nix`)
- [ ] Add Vaultwarden for password management (`modules/nixos/services/utilities/vaultwarden.nix`)
- [ ] Add Paperless-ngx for document management (`modules/nixos/services/utilities/paperless-ngx.nix`)

### *arr Suite Enhancements
- [ ] Add Recyclarr for *arr configuration management (`modules/nixos/services/downloads/recyclarr.nix`)
- [ ] Add Exportarr for *arr metrics export (`modules/nixos/services/monitoring/exportarr.nix`)

## 🤖 Automation Improvements

- [ ] Add security scanning GitHub workflow
- [ ] Add service health monitoring in CI
- [ ] Implement automated backup verification
- [ ] Create maintenance scripts
- [ ] Add deployment helpers
- [ ] Create service documentation
- [ ] Add configuration validation
