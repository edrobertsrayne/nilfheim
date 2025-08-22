# Nilfheim Configuration Improvements TODO

## 🚨 Critical Security Issues (IMMEDIATE)

- [X] Fix Plex TLS settings - remove TLS 1.0/1.1 (`modules/nixos/services/media/plex.nix:51-54`)
- [X] Add global nginx security headers (`modules/nixos/services/network/nginx.nix`)
- [X] Restrict service exposure - review `openFirewall = true` settings
- [X] Fix Grafana XSS vulnerability (`modules/nixos/services/monitoring/grafana.nix:127`)
- [X] Enhance SSH hardening with MaxAuthTries, ClientAliveInterval

## ⚠️ High Priority Infrastructure

- [ ] Add nginx proxyWebSockets to all exposed services
- [ ] Create Restic backup service (`modules/nixos/services/utilities/restic.nix`)
- [ ] Enable ZFS auto-snapshots with retention policies
- [ ] Add backup monitoring with Prometheus integration
- [X] Implement Loki + Promtail for log management
- [X] Add SMART monitoring for disk health
- [X] Create system health checks for ZFS and services
- [ ] Configure Blocky query logging to PostgreSQL database
- [ ] Create Grafana dashboard for DNS query monitoring and analytics

## 🔧 Code Refactoring

- [ ] Create `lib/services.nix` for service abstraction
- [ ] Create `lib/constants.nix` for centralized configuration
- [ ] Create `lib/nginx.nix` for proxy helpers
- [ ] Create `lib/secrets.nix` for secret management
- [ ] Refactor *arr services to eliminate duplication
- [ ] Standardize service configuration patterns
- [ ] Centralize port assignments
- [ ] Create service category modules

## 🛡️ Enhanced Security

- [ ] Add Authelia for SSO
- [ ] Configure service integration with Authelia
- [ ] Implement fail2ban for intrusion prevention
- [ ] Review Tailscale security settings
- [ ] Enhance Samba security restrictions

## 📊 Service Additions

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
