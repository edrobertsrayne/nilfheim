# Nilfheim Documentation

Comprehensive documentation for the Nilfheim NixOS/Darwin configuration system.

## 📚 Documentation Overview

Nilfheim documentation is organized into three main categories: **Architecture & Development**, **Operations**, and **Project Management**.

---

## Architecture & Development

### Core Documentation
- **[Main README](../README.md)** - Project overview, capabilities, quick start
- **[CLAUDE.md](../CLAUDE.md)** - Architecture overview, development guide, configuration patterns
- **[Command Reference](command-reference.md)** - Complete command documentation for all tools
- **[Documentation Standards](documentation-standards.md)** - Guidelines for creating and maintaining documentation

### Service Development
- **[Service Module Template](service-module-template.md)** - Standardized patterns for creating service modules
  - Code templates and examples
  - Best practices and naming conventions
  - Integration patterns (nginx, homepage, monitoring)

---

## Operations

### Infrastructure Management
- **[Backup Operations](backup-operations.md)** - Restic backup management and recovery
  - Checking backup status and viewing logs
  - Manual backup operations and repository management
  - Recovery procedures (selective and full system restore)
  - Repository maintenance and troubleshooting

- **[Monitoring](monitoring.md)** - Comprehensive monitoring and logging guide
  - Grafana dashboards and visualization
  - Loki log queries and patterns
  - Prometheus metrics and alerts
  - Database analytics (PostgreSQL/pgAdmin)
  - System health monitoring

- **[Troubleshooting](troubleshooting.md)** - Common issues and solutions
  - Development and build issues
  - Service and networking problems
  - Monitoring and logging issues
  - Backup, database, and container issues
  - Debug commands and performance tips

---

## Project Management

### Infrastructure Documentation
- **[Database Services](database-services.md)** - PostgreSQL and pgAdmin setup
  - PostgreSQL configuration and optimization
  - pgAdmin web interface
  - Service database integration patterns
  - Security and access control

- **[Monitoring Dashboards](monitoring-dashboards.md)** - Grafana dashboard details
  - Homelab Overview dashboard (23 panels)
  - DNS Analytics dashboard (21 panels)
  - Restic Backup Monitoring
  - Docker container metrics
  - System health and ZFS monitoring

### Planning
- **[TODO List](../TODO.md)** - Roadmap, planned improvements, pending tasks

---

## 🚀 Quick Navigation

### Getting Started
1. **[Main README](../README.md)** - Start here for project overview
2. **[CLAUDE.md](../CLAUDE.md)** - Architecture and development workflow
3. **[Command Reference](command-reference.md)** - Commands you'll need

### For Developers
- **Architecture**: See [CLAUDE.md Architecture Overview](../CLAUDE.md#architecture-overview)
- **Service Development**: See [CLAUDE.md Configuration Patterns](../CLAUDE.md#configuration-patterns)
- **Service Templates**: See [Service Module Template](service-module-template.md)
- **Documentation Guidelines**: See [Documentation Standards](documentation-standards.md)
- **Commands**: See [Command Reference](command-reference.md)

### For Operations
- **Backups**: See [Backup Operations](backup-operations.md)
- **Monitoring**: See [Monitoring](monitoring.md)
- **Troubleshooting**: See [Troubleshooting](troubleshooting.md)
- **Database Admin**: See [Database Services](database-services.md)

### For Infrastructure Planning
- **Dashboard Details**: See [Monitoring Dashboards](monitoring-dashboards.md)
- **Database Patterns**: See [Database Services](database-services.md)
- **Roadmap**: See [TODO.md](../TODO.md)

---

## 📝 Documentation Standards

### Structure
- **Clear hierarchy** - Use consistent heading levels
- **Practical examples** - Include working code snippets
- **Cross-references** - Link to related documentation
- **Concise** - Focus on essential information

### Content Guidelines
- **Code examples** - Test all commands and configurations
- **Troubleshooting** - Document common issues and solutions
- **Context** - Explain why, not just how
- **Updates** - Keep documentation current with system changes

### For Contributors
When contributing:
1. **Update relevant docs** - Changes should include documentation updates
2. **Follow patterns** - Use established structure and style
3. **Test examples** - Verify all code examples are functional
4. **Link appropriately** - Cross-reference related sections

---

## 📖 External Resources

- **[NixOS Manual](https://nixos.org/manual/nixos/stable/)** - Official NixOS documentation
- **[NixOS Options Search](https://search.nixos.org/options)** - Search available options
- **[Home Manager](https://nix-community.github.io/home-manager/)** - User environment management
- **[Nix Package Search](https://search.nixos.org/packages)** - Find packages in nixpkgs

---

*This documentation is maintained alongside the Nilfheim configuration and updated with each system enhancement.*
