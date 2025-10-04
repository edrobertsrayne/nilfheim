# Nilfheim - NixOS/Darwin Configuration

**See README.md for project overview and TODO.md for pending improvements.**

## Essential Commands

### Development Environment

```bash
# Enter development shell (includes claude-code, gh, git, alejandra, just)
nix develop

# See all available commands
just --list

# Run linting (format + static analysis + dead code detection) - REQUIRED before committing
just lint

# Run full validation (lint + comprehensive flake check) - REQUIRED before committing
just check
```

### Manual Development Commands

```bash
# Individual linting tools (use 'just lint' instead for full suite)
nix fmt .                    # Format only
statix check .               # Static analysis only  
deadnix -l .                 # Dead code detection only
nix flake check              # Flake validation only
```

### System Management

#### Quick Deployments (via Just)

```bash
# Deploy to hosts
just freya    # Local NixOS rebuild
just odin     # Local macOS rebuild
just thor     # Remote deployment to thor
just loki     # Remote deployment to loki
```

#### Manual NixOS (Linux)

```bash
# Local rebuild
sudo nixos-rebuild switch --flake .#<hostname>

# Remote rebuild (avoids cross-compilation)
nixos-rebuild switch --flake .#<hostname> --target-host <hostname> --build-host <hostname> --sudo

# Example: Deploy to thor
nixos-rebuild switch --flake .#thor --target-host thor --build-host thor --sudo

# Test in VM
nixos-rebuild build-vm --flake .#<hostname>

# Dry run (local)
sudo nixos-rebuild dry-run --flake .#<hostname>

# Dry run (remote)
nixos-rebuild dry-run --flake .#<hostname> --target-host <hostname> --build-host <hostname> --sudo
```

#### Manual Darwin (macOS)

```bash
# Rebuild system
darwin-rebuild switch --flake .#<hostname>

# Check configuration
darwin-rebuild check --flake .#<hostname>
```

#### Universal

```bash
# Update flake inputs
nix flake update

# Show system configuration
nix flake show
```

### Secrets Management

```bash
# Edit secrets (Linux only)
agenix -e secrets/<secret-name>.age

# Rekey all secrets
agenix -r
```

## Development Workflow

### Quick Development Loop

1. **Create feature branch**:
   - Features: `git checkout -b feat/feature-name`
   - Fixes: `git checkout -b fix/issue-name`

2. **Make changes** in `modules/` or `hosts/`

3. **Fast validation**: `just lint` (during development for quick feedback)

4. **Test builds**:
   - NixOS: `nixos-rebuild build-vm --flake .#<hostname>`
   - Darwin: `darwin-rebuild check --flake .#<hostname>`

5. **Repeat** until satisfied with changes

### Before Commit (MANDATORY)

1. **Final validation**: `just check` - **MUST PASS completely with zero
   errors/warnings**

2. **Test configuration**: Deploy to test environment or VM

3. **Commit**: Use conventional format `type(scope): description`
   - Examples:
     - `feat(homelab): add navidrome music server`
     - `fix(security): enable sudo password requirement`
     - `refactor(services): create service abstraction library`

4. **Apply changes**:
   - Quick: `just <hostname>` (freya, odin, thor, loki)
   - Manual NixOS local: `sudo nixos-rebuild switch --flake .#<hostname>`
   - Manual NixOS remote:
     `nixos-rebuild switch --flake .#<hostname> --target-host <hostname> --build-host <hostname> --sudo`
   - Manual Darwin: `darwin-rebuild switch --flake .#<hostname>`

### Branch Management

- **Before PR**: `git rebase main`
- **Quality checks**: `just ci-quality-dry` (fast validation)
- **Local CI testing**: `just ci-validate` (comprehensive validation)

### Pre-commit Checklist

- [ ] Run `just check` - **MUST PASS without errors or warnings**
- [ ] Run `just ci-quality-dry` (fast validation)
- [ ] Verify no formatting changes: `git diff`
- [ ] Test configuration builds
- [ ] Test in VM (NixOS) or check (Darwin)
- [ ] Rebase against main
- [ ] Use conventional commit format

**CRITICAL**: `just check` must complete successfully with zero errors and zero
warnings before any commit can be made. This includes:

- ✅ Formatting (alejandra)
- ✅ Static analysis (statix)
- ✅ Dead code detection (deadnix)
- ✅ Flake validation (nix flake check)

### Local CI Testing

```bash
# Quick validation
just ci-quality-dry    # Dry run quality checks
just ci-validate       # Full validation suite

# Run specific workflows
just ci-list           # See available workflows
just ci-quality        # Run quality checks
just ci-format         # Run formatting workflow
just ci-pr             # Simulate pull request
```

### Running Commands Without Installation

```bash
# Syntax: nix run nixpkgs#<package>
nix run nixpkgs#jq
nix run nixpkgs#curl
nix run nixpkgs#tree
nix run nixpkgs#htop

# Example with pipes
curl -s http://api.example.com | nix run nixpkgs#jq -- '.data'
```

## Troubleshooting

### Common Issues

| Issue                    | Solution                                          |
| ------------------------ | ------------------------------------------------- |
| Permission errors        | Enter development shell: `nix develop`            |
| Build failures           | Update flake inputs: `nix flake update`           |
| Secret access            | Verify agenix keys configuration                  |
| Hardware issues          | Update hardware-configuration.nix                 |
| Platform mismatch        | Use correct rebuild command for your OS           |
| Cross-compilation        | Use `--build-host` for remote deployments         |
| **Linting errors**       | **Run `just lint` and fix all warnings**          |
| **Flake check failures** | **Run `nix flake check` and resolve errors**      |
| **Service conflicts**    | **Check port assignments in `lib/constants.nix`** |
| **Module import errors** | **Verify file paths and module structure**        |

### Debug Commands

```bash
# Check flake evaluation (current architecture only)
nix flake check --systems "$(nix eval --impure --raw --expr 'builtins.currentSystem')"

# Show build logs
nix log .#nixosConfigurations.<hostname>.config.system.build.toplevel
```

### Performance Tips

```bash
# Faster flake checks (current system only)
nix flake check --systems "$(nix eval --impure --raw --expr 'builtins.currentSystem')"

# Parallel builds for faster rebuilds
nixos-rebuild switch --flake .#<hostname> --builders 'ssh://build-host x86_64-linux'

# Local development with build caching
nixos-rebuild build-vm --flake .#<hostname> --option builders ''

# Quick syntax check without full build
nix eval .#nixosConfigurations.<hostname>.config.system.build.toplevel --dry-run
```

## Backup and Monitoring

### Backup System Management

**Check Backup Status:**
```bash
# Check backup service and timer status
systemctl status restic-backups-system.service
systemctl status restic-backups-system.timer
systemctl list-timers | grep restic

# View backup logs
journalctl -u restic-backups-system.service -f
journalctl -u restic-backups-system.service --since "24 hours ago"
```

**Manual Backup Operations:**
```bash
# Trigger immediate backup
systemctl start restic-backups-system.service

# Check repository status
export RESTIC_REPOSITORY=/mnt/backup/$(hostname)/restic
export RESTIC_PASSWORD_FILE=/etc/restic/password
restic snapshots
restic stats

# Validate repository integrity
restic check
restic check --read-data-subset=10%
```

**Repository Management:**
```bash
# Manual cleanup (retention policy is automated)
restic forget --keep-daily 14 --keep-weekly 8 --keep-monthly 6 --keep-yearly 2 --prune

# Emergency unlock (if repository is locked)
restic unlock

# Browse snapshot contents
restic ls latest
restic find "*.nix" --snapshot latest
```

**Backup Recovery:**
```bash
# List files in snapshot
restic ls latest --long /persist/home

# Restore specific files
restic restore latest --target /tmp/restore --include /persist/important-file

# Restore full directory
restic restore latest --target /tmp/restore --include /persist/home/user
```

### Monitoring and Logging

**Loki Log Queries:**
```bash
# Backup monitoring
{job="systemd-journal", unit="restic-backups-system.service"}
{job="systemd-journal", unit="restic-backups-system.service"} |= "ERROR"
{job="systemd-journal", unit="restic-backups-system.service"} |= "completed"

# System service errors
{job="systemd-journal"} |= "ERROR"
{job="systemd-journal"} |= "failed"

# Application logs
{job="arr-services", level="Error"}
{job="jellyfin"} |= "ERROR"
{job="nginx-error"}

# SSH and authentication
{job="systemd-journal", unit="sshd.service"}
{job="systemd-journal"} |= "authentication"
```

**Monitor System Health:**
```bash
# Check Loki/Promtail status
systemctl status loki.service
systemctl status promtail.service

# Check stream limits and metrics
curl -s localhost:3100/metrics | grep -E "stream|ingester"
curl -s localhost:3100/loki/api/v1/label/job/values

# View Grafana dashboards
https://grafana.${domain}/d/restic-backup/restic-backup-monitoring
https://grafana.${domain}/explore  # Loki explorer
```

**Log Collection Troubleshooting:**
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

**Common Monitoring Issues:**

| Issue                    | Solution                                          |
| ------------------------ | ------------------------------------------------- |
| Stream limit exceeded    | Check cardinality, reduce labels                 |
| Timestamp errors         | Disable timestamp parsing, use ingestion time    |
| No backup logs          | Verify systemd journal collection               |
| High memory usage        | Adjust retention, stream limits                   |
| Missing application logs | Check file permissions, service groups           |

## Service Configuration

### Nginx Proxy Services

**Standard Configuration:**

```nix
services.nginx.virtualHosts."${cfg.url}" = {
  locations."/" = {
    proxyPass = "http://127.0.0.1:${toString port}";
    proxyWebsockets = true;  # Enables WebSocket support
  };
};
```

**Avoid:**

- Custom proxy headers in `extraConfig`
- Duplicate WebSocket headers
- Override timeout/buffer settings

**Reason:** NixOS provides recommended proxy settings automatically, including:

- Proxy headers (Host, X-Forwarded-*, X-Real-IP)
- WebSocket upgrade mapping
- Optimal timeouts and buffers
- Security headers

**Exceptions:**

- Static assets: May need additional location blocks
- Service-specific headers: Only if required by the application

### ZFS Snapshots

**Configuration:**

```nix
services.zfs.autoSnapshot = constants.snapshotRetention // {
  enable = true;
};
```

**Standard Retention Policy (from lib/constants.nix):**

- frequent = 4 (15-minute snapshots)
- hourly = 24
- daily = 14 (2 weeks)
- weekly = 8 (2 months)
- monthly = 6 (6 months)

**Requirements:**

- ZFS datasets must have `com.sun:auto-snapshot=true` property
- Only for NixOS systems with ZFS pools
- Not applicable to Darwin or non-ZFS systems

### NFS Shared Storage

**Server Configuration (Thor):**

```nix
services.nfs-server = {
  enable = true;
  shares = {
    downloads = {
      source = constants.paths.downloads;  # Uses centralized paths
      permissions = "rw";
    };
    media = {
      source = constants.paths.media;
      permissions = "ro";
    };
    # ... additional shares
  };
};
```

**Client Configuration (Freya):**

```nix
services.nfs-client = {
  enable = true;
  server = "thor";  # Uses tailscale MagicDNS
  mounts = {
    media = {
      remotePath = "/media";
      localPath = "/mnt/media";
      options = ["soft" "intr" "bg" "vers=4" "ro"];
    };
    # ... additional mounts
  };
};
```

**Features:**

- Automatic export over tailscale network (100.64.0.0/10)
- Proper firewall configuration for NFS ports (2049, 111, 20048)
- Soft mounting with background and interrupt support
- Integration with existing Samba shares

### Database Services

**PostgreSQL Configuration:**

```nix
services.postgresql = {
  enable = true;
  package = pkgs.postgresql_16;
  dataDir = "${constants.paths.dataDir}/postgresql";
  enableTCPIP = true;
  
  settings = {
    port = constants.ports.postgresql;
    max_connections = 100;
    shared_buffers = "256MB";
    effective_cache_size = "1GB";
    log_statement = "all";
    log_min_duration_statement = 1000;
  };
};
```

**pgAdmin Web Interface:**

```nix
services.pgadmin = {
  enable = true;
  port = constants.ports.pgadmin;
  initialEmail = config.user.email;
  initialPasswordFile = pkgs.writeText "pgadmin_password" "password123";
};

# Homepage integration
services.homepage-dashboard.homelabServices = [{
  group = "Data";
  name = "pgAdmin";
  entry = {
    href = "https://pgadmin.${config.homelab.domain}";
    icon = "postgresql.svg";
    siteMonitor = "http://127.0.0.1:${toString constants.ports.pgadmin}";
    description = "PostgreSQL administration interface";
  };
}];

# Nginx proxy
services.nginx.virtualHosts."pgadmin.${config.homelab.domain}" = {
  locations."/" = {
    proxyPass = "http://127.0.0.1:${toString constants.ports.pgadmin}";
    proxyWebsockets = true;
  };
};
```

**Database Integration Patterns:**

- **Centralized Configuration**: Use `lib/constants.nix` for ports, paths, and
  network settings
- **Security**: Implement proper authentication with tailscale network
  restrictions
- **Monitoring**: Enable query logging and performance metrics for Grafana
  integration
- **Backup Ready**: Configure data directories with proper permissions for
  backup services
- **Service Integration**: Automatic database and user creation for dependent
  services (e.g., Blocky)

**Example Service Database Integration:**

```nix
# In service module (e.g., Blocky DNS)
services.postgresql.initialScript = pkgs.writeText "service-init.sql" ''
  CREATE DATABASE ${config.services.servicename.database.name};
  CREATE USER ${config.services.servicename.database.user} WITH PASSWORD '${config.services.servicename.database.password}';
  GRANT ALL PRIVILEGES ON DATABASE ${config.services.servicename.database.name} TO ${config.services.servicename.database.user};
'';

# Firewall configuration for database access
networking.firewall.interfaces.tailscale0.allowedTCPPorts = [constants.ports.postgresql];
```

## Service Development Guidelines

### Service Abstractions

**When to Use lib/services.nix Abstractions:**

- Services with high code similarity (80%+ duplication)
- Consistent configuration patterns across multiple services
- Example: *arr services (sonarr, radarr, lidarr) use `mkArrService`

**When NOT to Use Abstractions:**

- Complex services with unique requirements (Jellyfin, Plex, Prometheus)
- Simple services (30-50 lines) where abstraction adds overhead
- Services with service-specific configuration needs

**Available Abstractions:**

- `mkArrService`: For *arr applications with Prometheus exporters, homepage
  integration, nginx proxy

### Adding a New Service

1. Check if existing abstractions apply (`lib/services.nix`)
2. Follow existing service patterns in `modules/nixos/services/`
3. Use centralized ports from `lib/constants.nix`
4. Add homepage integration via `homelabServices`
5. Configure nginx proxy with `proxyWebsockets = true`
6. **Database Services**: If adding database-dependent service:
   - Configure PostgreSQL integration in service module
   - Add database initialization script
   - Set up proper authentication and network access
   - Consider backup requirements and monitoring integration
7. Run `just check` before committing

### Refactoring Existing Services

1. Identify code duplication patterns
2. Consider if abstraction would benefit (see guidelines above)
3. **CRITICAL**: Only add abstraction if it has immediate benefit - avoid
   creating unused layers
4. Focus on eliminating actual duplication (paths, settings, configurations)
5. Test thoroughly with `nixos-rebuild build-vm`
6. Ensure `just check` passes with zero warnings

### Refactoring Best Practices

- **Immediate Benefit Only**: Don't create abstractions that aren't actively
  used
- **Single Source of Truth**: Eliminate duplicate definitions across files
- **Use Existing Centralization**: Reference `lib/constants.nix` for paths,
  ports, settings
- **Keep It Simple**: Prefer simple reference to constants over complex
  abstractions
- **Test Impact**: Ensure refactoring doesn't break existing functionality

## Security Configuration

### Authentication & Access Control

**Sudo Configuration:**

- Password required for all sudo operations (`wheelNeedsPassword = true`)
- No passwordless sudo access for security

**SSH Hardening:**

- Key-based authentication only (`PasswordAuthentication = false`)
- Root login disabled (`PermitRootLogin = "no"`)
- Maximum 3 authentication attempts before connection drop
- Connection timeout after 5 minutes of inactivity

### Intrusion Prevention

**Fail2ban Configuration:**

```nix
services.fail2ban = {
  enable = true;
  # SSH protection: 3 attempts, 10min window, 24h ban
  # Progressive ban time increases up to 7 days
  # Nginx HTTP auth and bad request detection
  # Custom filtering for security monitoring
};
```

**Features:**

- SSH brute force protection (3 attempts → 24h ban)
- Nginx HTTP authentication failure detection
- Request rate limiting protection
- Progressive ban time increases (exponential backoff)
- Comprehensive log monitoring and analysis

### Network Security

**Service Isolation:**

- SMB/Samba restricted to tailscale network only (100.64.0.0/10)
- NFS exports limited to tailscale CGNAT range
- Manual firewall rules for enhanced control
- Avahi/Jellyfin accessible to local network (per requirement)

**Network Architecture:**

- Tailscale mesh VPN for secure remote access
- Interface-specific firewall rules
- Service-specific port restrictions
- Proper network segmentation

## Code Quality Standards

### Required Before Any Commit

- ✅ `just check` passes with ZERO errors and ZERO warnings
- ✅ All services build successfully
- ✅ Configuration tested (VM for NixOS, check for Darwin)
- ✅ Conventional commit format used

### Code Review Guidelines

- Services should use existing abstractions when applicable
- Avoid code duplication (DRY principle)
- Follow existing naming conventions
- Include proper documentation comments
- Use centralized constants for ports and paths
