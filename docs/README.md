# Nilfheim Documentation

Comprehensive documentation for the Nilfheim NixOS/Darwin configuration system.

## 📚 Documentation Index

### Core Documentation
- **[Main README](../README.md)** - Project overview and quick start guide
- **[Development Workflow](../CLAUDE.md)** - Complete development commands and patterns
- **[TODO List](../TODO.md)** - Planned improvements and pending tasks

### Infrastructure Documentation

#### 🗄️ Database Services
- **[Database Services](./database-services.md)** - PostgreSQL, pgAdmin, and integration patterns
  - PostgreSQL configuration and optimization
  - pgAdmin web interface setup
  - Service database integration patterns
  - Security configuration and access control
  - Administration tasks and maintenance

#### 📊 Monitoring & Analytics  
- **[Monitoring Dashboards](./monitoring-dashboards.md)** - Grafana dashboards and analytics
  - Blocky DNS analytics dashboard (21 panels)
  - System health and ZFS monitoring  
  - Service logs and application monitoring
  - Nginx access logs and security analytics
  - Promtail log pipeline monitoring

### Service Categories

#### 🎬 Media Services
- Jellyfin, Audiobookshelf, Jellyseerr, Kavita
- *arr suite (Sonarr, Radarr, Lidarr, Bazarr, Prowlarr)
- Integration with monitoring and analytics

#### 📥 Download Management
- Transmission, Recyclarr, Flaresolverr
- Automated media acquisition workflows

#### 🌐 Network Services  
- Nginx reverse proxy configuration
- Blocky DNS with logging and analytics
- Tailscale mesh networking
- NFS shared storage over secure networks

#### 📈 Monitoring Stack
- Prometheus metrics collection
- Grafana visualization and dashboards
- Loki log aggregation with Promtail
- AlertManager notification routing

#### 💾 Storage & Backup
- ZFS filesystem with snapshots
- NFS server/client for shared storage
- Automated backup planning (Restic)

### Advanced Topics

#### 🔐 Security Configuration
- SSH hardening and key-based authentication
- Fail2ban intrusion prevention
- Network segmentation with Tailscale
- Service isolation and access control

#### 🐳 Container Management
- Podman rootless containerization  
- Systemd integration for containers
- Container monitoring and log analysis

#### 🏗️ Infrastructure as Code
- NixOS modular configuration patterns
- Service abstraction and reusability
- Centralized configuration management
- Declarative system management

## 🚀 Quick Navigation

### Getting Started
1. Read the [Main README](../README.md) for project overview
2. Follow [Development Workflow](../CLAUDE.md) for setup instructions
3. Review [Database Services](./database-services.md) for data infrastructure
4. Explore [Monitoring Dashboards](./monitoring-dashboards.md) for analytics

### For Developers
- Service development patterns in [CLAUDE.md](../CLAUDE.md)
- Database integration examples in [Database Services](./database-services.md)
- Monitoring setup in [Monitoring Dashboards](./monitoring-dashboards.md)

### For System Administration
- Daily operations covered in individual service documentation
- Monitoring and alerting setup in dashboard documentation
- Security hardening guidelines in main documentation

## 📝 Documentation Standards

### Writing Guidelines
- **Clear Structure**: Use consistent headings and organization
- **Code Examples**: Include practical configuration examples
- **Troubleshooting**: Document common issues and solutions
- **Cross-References**: Link related documentation sections

### Maintenance
- Update documentation with any configuration changes
- Validate code examples during system updates
- Keep screenshots and examples current with actual system state
- Review and update quarterly for accuracy

## 🤝 Contributing

When contributing to the project:

1. **Document Changes**: Update relevant documentation files
2. **Follow Patterns**: Use established documentation patterns and structure
3. **Include Examples**: Provide practical configuration examples
4. **Cross-Reference**: Link to related documentation sections
5. **Test Examples**: Verify all code examples are functional

## 📞 Support

For questions or issues:

1. Check relevant documentation section first
2. Review [TODO.md](../TODO.md) for known issues
3. Search existing GitHub issues
4. Create new GitHub issue with detailed description

---

*This documentation is maintained alongside the Nilfheim configuration and updated with each system enhancement.*