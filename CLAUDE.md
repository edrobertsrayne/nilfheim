# Nilfheim - NixOS/Darwin Configuration

AI assistant context document for developing Nilfheim, a modular NixOS and
Darwin flake configuration for system management across multiple hosts.

**See README.md for project overview and features.**

---

## Architecture Overview

### System Topology

Nilfheim manages four hosts with distinct roles:

- **Freya** - Lenovo ThinkPad T480s workstation/laptop
  - Roles: common, workstation
  - Desktop: GNOME/Hyprland with GDM, gaming support (Steam, gamemode)
  - Storage: ZFS with impermanence, NFS client
  - Persistence: `/persist` (system) + `/home` (user data)

- **Thor** - Homelab server (primary infrastructure)
  - Role: server
  - Services: Media (*arr suite, Jellyfin), monitoring stack, databases
  - Storage: ZFS pool (`tank`), NFS server, Samba shares
  - Network: Central hub for tailscale mesh, runs DNS (Blocky), reverse proxy
    (Nginx)
  - All homelab services configured directly in host config

- **Loki** - VPS server
  - Role: vps
  - Lightweight configuration for cloud deployment

- **Odin** - macOS system
  - Platform: Darwin (x86_64)
  - Cross-platform development environment

### Module Organization

```
nilfheim/
├── flake.nix              # Flake outputs, dev shell, host configurations
├── hosts/                 # Host-specific configurations
│   ├── default.nix        # Host factory functions (mkNixosSystem, mkDarwinSystem)
│   ├── freya/             # Laptop-specific config, disko, hardware
│   ├── thor/              # Server-specific config, ZFS, shares
│   ├── loki/              # VPS-specific config
│   └── odin/              # macOS-specific config
├── modules/
│   ├── common/            # Shared across all platforms
│   ├── nixos/             # NixOS-specific modules
│   │   ├── services/      # Service modules by category
│   │   │   ├── data/      # PostgreSQL, pgAdmin
│   │   │   ├── monitoring/# Grafana, Prometheus, Loki, Promtail
│   │   │   ├── media/     # *arr services, Jellyfin, Jellyseerr
│   │   │   ├── network/   # Blocky DNS, Nginx, Tailscale, NFS
│   │   │   └── ...
│   ├── darwin/            # macOS-specific modules
│   └── home/              # Home-manager user environment
├── roles/                 # Predefined role combinations
│   ├── common.nix         # Base configuration for all hosts
│   ├── server.nix         # Server-specific (Docker, tailscale routing, portainer)
│   ├── workstation.nix    # Desktop/laptop (GNOME/Hyprland, apps, power, gaming)
│   └── vps.nix            # VPS-optimized configuration
├── lib/
│   ├── constants.nix      # Centralized ports, paths, settings
│   ├── services.nix       # Service abstraction helpers (mkArrService)
│   └── default.nix        # Library namespace
└── secrets/               # agenix encrypted secrets
```

### Service Architecture

**Homelab Stack (Thor):**

```
Network Layer:
  Tailscale (mesh VPN) → Blocky (DNS) → Nginx (reverse proxy) → Services

Storage Layer:
  ZFS (tank pool) → NFS exports → Samba shares
  ├── /mnt/media (read-only)
  ├── /mnt/downloads (read-write)
  └── /mnt/backup (restic repositories)

Services Layer:
  Media: Jellyfin, Jellyseerr, *arr suite (Sonarr/Radarr/Lidarr/Bazarr/Prowlarr)
  Download: Transmission (direct IP + proxy, peer port 51413), SABnzbd (Usenet), Flaresolverr, Recyclarr, Cleanuparr, Huntarr
  Monitoring: Grafana ← Prometheus ← Exporters (node, exportarr, cAdvisor)
              Loki ← Promtail ← Logs (systemd, docker, apps)
              Alertmanager ← 54 alert rules (system, network, containers, logs, backups)
  Data: PostgreSQL (DNS analytics) ← Blocky queries
  Containers: Docker (Home Assistant, Tdarr, Cleanuparr, Huntarr, Portainer)
              Auto-pull enabled for all containers
  Utilities: Homepage (dashboard), Code-server, N8N, Mealie

Backup System:
  Restic → Local repositories → Monitored via Loki/Grafana alerts
```

**Client Configuration (Freya):**

```
Desktop: GNOME/Hyprland → GDM display manager
Storage: ZFS + impermanence (ephemeral root, persistent /home)
Network: Tailscale client → NFS mounts from Thor
Development: VSCode, Firefox, terminal tools
```

### Key Design Decisions

**Why Service Abstractions?**

- The *arr services (Sonarr, Radarr, Lidarr, Bazarr, Prowlarr) share 80%+
  identical configuration
- `lib/services.nix` provides `mkArrService` to eliminate duplication
- Each service gets: nginx proxy, homepage integration, Prometheus exporter,
  standardized paths
- Trade-off: Only used when duplication is high; complex services (Jellyfin,
  Prometheus) remain standalone

**Why Centralized Constants?**

- `lib/constants.nix` is single source of truth for 66+ service ports, paths,
  network settings
- Build-time validation prevents port conflicts (automatically checks for
  duplicates)
- Consistent paths across services reduce configuration errors
- Changes propagate automatically (e.g., changing data directory affects all
  services)

**Why Role-Based Configuration?**

- Roles compose related modules for common use cases
- Hosts select roles: `thor = [server]`, `freya = [common workstation]`
- Avoids repeating module lists per host
- Easy to test new combinations across hosts
- Host-specific services (like Thor's homelab stack) live in host configs
- Workstation role includes gaming support (Steam, gamemode, gaming apps)

**Why Tailscale + NFS + Samba?**

- Tailscale: Secure mesh network, MagicDNS simplifies hostnames
- NFS: High-performance file sharing over tailscale for authenticated clients
- Samba: Local network access for devices without tailscale (TVs, phones on LAN)
- Security: NFS restricted to tailscale network (100.64.0.0/10), Samba requires
  authentication

---

## Development Guide

### Standard Workflow

```bash
# 1. Enter development environment
nix develop

# 2. Create feature branch
git checkout -b feat/add-service-name

# 3. Make changes in modules/ or hosts/

# 4. Update documentation (if applicable)
# - Add/update service documentation
# - Update relevant guides (CLAUDE.md, README.md, docs/)
# - Follow docs/documentation-standards.md

# 5. Lint during development (fast feedback)
just lint

# 6. Full validation before commit (MANDATORY)
just check  # MUST pass with zero errors/warnings

# 7. Test configuration
just thor   # or freya/odin/loki

# 8. Commit with conventional format
git commit -m "feat(services): add service-name with monitoring"

# 9. Deploy
just <hostname>
```

### Quality Requirements (Non-Negotiable)

Before **any** commit:

- ✅ `just check` passes with **ZERO errors and ZERO warnings**
- ✅ Configuration builds successfully
- ✅ Changes tested (VM for NixOS, check for Darwin)
- ✅ Conventional commit format: `type(scope): description`

`just check` runs:

1. `alejandra` - Nix code formatting
2. `statix` - Static analysis for anti-patterns
3. `deadnix` - Dead code detection
4. `nix flake check` - Flake validation

### Branch Management

- Feature branches: `feat/feature-name`
- Bug fixes: `fix/issue-name`
- Refactoring: `refactor/scope`
- Before PR: `git rebase main`

---

## Configuration Patterns

### Service Development

#### When to Use Service Abstractions

**Use `lib/services.nix` abstractions when:**

- Services have 80%+ code similarity
- Consistent configuration patterns across multiple instances
- Example: `mkArrService` for *arr applications (Sonarr, Radarr, Lidarr, Bazarr,
  Prowlarr)

**Do NOT use abstractions when:**

- Service has unique requirements (Jellyfin, Plex, Prometheus)
- Service is simple (30-50 lines) and abstraction adds overhead
- Service has service-specific configuration that doesn't fit pattern

**Critical Rule:** Only create abstractions with immediate benefit. Avoid unused
layers.

#### Adding a New Service

1. **Check for existing patterns**: Review `lib/services.nix` for applicable
   abstractions
2. **Choose port**: Add to `lib/constants.nix` (automatic conflict detection)
3. **Create module**: Follow structure in `modules/nixos/services/<category>/`
4. **Configure service**:
   ```nix
   {config, lib, nilfheim, ...}:
   let
     inherit (nilfheim) constants;  # ALWAYS use nilfheim namespace
   in {
     # Use centralized ports and paths
     port = constants.ports.servicename;
     dataDir = "${constants.paths.dataDir}/servicename";
   }
   ```
5. **Add nginx proxy**:
   ```nix
   services.nginx.virtualHosts."${cfg.url}" = {
     locations."/" = {
       proxyPass = "http://127.0.0.1:${toString port}";
       proxyWebsockets = true;  # NixOS handles headers automatically
     };
   };
   ```
6. **Homepage integration**:
   ```nix
   services.homepage-dashboard.homelabServices = [{
     group = "Category";
     name = "ServiceName";
     entry = {
       href = "https://${cfg.url}";
       icon = "icon.svg";
       siteMonitor = "http://127.0.0.1:${toString port}";
     };
   }];
   ```
7. **Database integration** (if needed):
   ```nix
   services.postgresql.initialScript = pkgs.writeText "init.sql" ''
     CREATE DATABASE ${dbName};
     CREATE USER ${dbUser} WITH PASSWORD '${dbPass}';
     GRANT ALL PRIVILEGES ON DATABASE ${dbName} TO ${dbUser};
   '';

   networking.firewall.interfaces.tailscale0.allowedTCPPorts = [constants.ports.postgresql];
   ```
8. **Update documentation** (follow [docs/documentation-standards.md](docs/documentation-standards.md)):
   - Add service to README.md capabilities section (if user-facing)
   - Update docs/README.md with any new operational guides
   - Document configuration in service-specific docs (if complex)
9. **Run `just check`** before committing

#### Service Configuration Standards

**Nginx Proxy:**

- Use `proxyWebsockets = true` for WebSocket support
- NixOS automatically provides: Host header, X-Forwarded-* headers, timeouts,
  buffers
- Avoid custom `extraConfig` unless service requires specific headers

**Port Allocation:**

- All ports defined in `lib/constants.nix`
- Automatic validation prevents conflicts
- Ports organized by category (monitoring, media, network, etc.)

**Data Directories:**

- Use `constants.paths.dataDir` as base (`/srv`)
- Service data: `${constants.paths.dataDir}/servicename`
- Media paths: `constants.paths.media`, `.movies`, `.tv`, `.music`
- Download path: `constants.paths.downloads`

**Type Safety:**

- All `mkOption` declarations include `type` constraints
- Use `types.str`, `types.port`, `types.path`, `types.bool`, etc.
- Prevents configuration errors at build time

**Conditional Dependencies:**

- Use conditional blocks for optional features
- Example: Blocky PostgreSQL logging only when PostgreSQL is enabled
- Prevents runtime failures from missing dependencies

#### Docker Container Modules

**Located in:** `modules/nixos/virtualisation/*.nix`

**When to Use Docker Containers:**
- Applications without native NixOS modules
- Upstream provides well-maintained container images
- Self-contained applications without complex host integration
- Examples: Cleanuparr, Huntarr, Home Assistant, Tdarr, Portainer

**Docker Volumes vs Bind Mounts:**
- **Use Docker volumes** for self-contained app config (Cleanuparr, Huntarr, Portainer data)
- **Use bind mounts** when needing host filesystem access (Tdarr media, Home Assistant config editing)
- **Always bind mount** for required host resources (docker.sock for Portainer)

**Standard Docker Module Pattern:**
```nix
{lib, config, nilfheim, ...}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.virtualisation.servicename;
in {
  options.virtualisation.servicename = {
    enable = mkEnableOption "...";
    port = mkOption { type = int; default = constants.ports.servicename; };
    url = mkOption { type = str; default = "servicename.${config.domain.name}"; };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."servicename" = {
      image = "image:tag";
      ports = ["${toString cfg.port}:${toString cfg.port}"];
      volumes = ["servicename-config:/config"];  # Docker volume (not bind mount)
      extraOptions = ["--pull=always"];  # Auto-update on rebuild
    };

    services.nginx.virtualHosts."${cfg.url}" = {
      locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      locations."/".proxyWebsockets = true;
    };

    services.homepage-dashboard.homelabServices = [{
      group = "Category";
      name = "ServiceName";
      entry = {
        href = "https://${cfg.url}";
        icon = "icon.svg";
        siteMonitor = "http://127.0.0.1:${toString cfg.port}";
      };
    }];
  };
}
```

**Auto-Pull Strategy:**
- All containers use `--pull=always` for automatic updates on rebuild
- Ensures latest security patches and features without manual intervention
- Trade-off: Less reproducible, potential breaking changes
- Alternative: Pin specific image versions if stability is critical

**Module Registration:**
- Add to `modules/nixos/virtualisation/default.nix` imports
- Enable in host config: `virtualisation.servicename.enable = true;`

### Security Architecture

#### Authentication & Access Control

- **SSH**: Key-based only, no password authentication, no root login
- **Sudo**: Password required for all operations (`wheelNeedsPassword = true`)
- **Fail2ban**: Progressive bans (24h → 7d) for SSH/nginx attacks
- **Secrets**: agenix encryption with age keys per host

#### Network Segmentation

```
Internet
  ↓
Cloudflare Tunnel (public services)
  ↓
Tailscale Mesh (100.64.0.0/10)
  ↓
Services (interface-specific firewall rules)
  ├── SMB/NFS: tailscale0 only
  ├── Web services: reverse proxy (nginx)
  └── Local services: lo (loopback)

Exceptions:
- Avahi: Local network (for discovery)
- Jellyfin: Local network + tailscale (for devices)
```

**Firewall Strategy:**

- Manual control over interface-specific rules
- Tailscale network: `networking.firewall.interfaces.tailscale0.allowedTCPPorts`
- Local network: `networking.firewall.allowedTCPPorts` (minimal)
- Service isolation: Only required ports exposed per interface

#### Security Features

- **SSH Hardening**: MaxAuthTries=3, ClientAliveInterval=300, key-only auth
- **Intrusion Prevention**: Fail2ban monitors SSH, nginx auth, bad requests
- **Storage Security**: NFS over tailscale, Samba with authentication
- **Service Isolation**: Minimal port exposure, interface-specific rules
- **Encryption**: Secrets (agenix), backups (Restic), tunnels
  (Tailscale/Cloudflare)

---

## Project Conventions

### File Organization

- **Modules**: Category-based (`services/<category>/<service>.nix`)
- **Hosts**: One directory per host with `default.nix`,
  `disko-configuration.nix`, `hardware-configuration.nix`
- **Roles**: Predefined combinations of modules
- **Library**: Shared functions, constants, abstractions

### Naming Conventions

- **Modules**: Lowercase with hyphens (`blocky-dns.nix`)
- **Options**: Camel case (`services.serviceName.enable`)
- **Constants**: Lowercase with hyphens (`constants.ports.service-name`)
- **Secrets**: Lowercase with `.age` extension (`secret-name.age`)

### Library Import Convention

**CRITICAL: Always use the `nilfheim` namespace for library imports. Never use relative paths.**

```nix
# CORRECT - Use nilfheim namespace
{config, lib, nilfheim, ...}:
let
  inherit (nilfheim) constants;
in {
  # Access: constants.ports.servicename
}

# WRONG - Never use relative imports
{config, lib, ...}:
let
  constants = import ../../../../lib/constants.nix;  # DO NOT DO THIS
in {
  # ...
}
```

**Rationale:**
- Single source of truth for library access
- Easier refactoring and maintenance
- Prevents broken imports when moving files
- Consistent across all modules

### Critical Constraints

**Port Uniqueness:**

- All ports in `lib/constants.nix` are validated at build time
- Duplicate port assignment causes build failure
- 66+ ports automatically checked

**Type Constraints:**

- Every `mkOption` must include `type` parameter
- Follows NixOS module system best practices
- Build-time validation prevents runtime errors

**Dependency Management:**

- Optional features use conditional blocks
- Hard dependencies avoided when feature is optional
- Example:
  ```nix
  config = mkIf cfg.enable {
    services.postgresql = mkIf cfg.database.enable {
      # PostgreSQL configuration
    };
  };
  ```

**Single Source of Truth:**

- Ports: `lib/constants.nix`
- Paths: `lib/constants.nix`
- Network ranges: `lib/constants.nix`
- No duplicate definitions across files

---

## NixOS Best Practices

### Simplicity First

- Prefer simple, explicit configuration over clever abstractions
- Avoid premature optimization - solve real problems, not hypothetical ones
- If configuration is hard to understand, it's hard to maintain

### Incremental Development

- Break features into small, testable tasks
- Implement one task completely before moving to the next
- Test each task: build, deploy to test host, verify functionality
- Commit working increments - avoid large, untested changesets
- If a task fails, rollback and debug before continuing

### Configuration Readability

- Use descriptive variable names and option values
- Extract complex expressions into `let` bindings with clear names
- Add comments for non-obvious decisions or workarounds
- Remove unused code immediately - don't leave it "just in case"

---

## Quick Reference

### Essential Commands

```bash
# Development
nix develop              # Enter dev environment
just lint                # Quick validation
just check               # Full validation (required before commit)

# Deployment
just freya               # Deploy to freya
just thor                # Deploy to thor
just odin                # Deploy to odin
just loki                # Deploy to loki
```

### Key Files

```
lib/constants.nix        # Ports, paths, network settings
lib/services.nix         # Service abstractions (mkArrService)
hosts/default.nix        # Host factory functions
roles/                   # Role compositions
modules/nixos/services/  # Service modules
secrets/                 # Encrypted secrets (agenix)
```

### Commit Format

```
feat(scope): add new feature
fix(scope): fix bug
refactor(scope): restructure code
docs(scope): update documentation
chore(scope): maintenance tasks
```

### Port Quick Lookup

```
Grafana: 3000            Homepage: 3002          Loki: 3100
Prometheus: 9090         Blocky: 4000            PostgreSQL: 5432
Jellyfin: 8096           Sonarr: 8989            Radarr: 7878
Transmission: 9091       Cleanuparr: 11011       Huntarr: 9705
Nginx: 80/443
Transmission peer: 51413 (open for torrent traffic)
```

---

## Additional Resources

**Documentation Index:**

- [docs/README.md](docs/README.md) - Complete documentation index and navigation

**Operational Documentation:**

- [Backup Operations](docs/backup-operations.md) - Restic backup management,
  recovery procedures
- [Monitoring](docs/monitoring.md) - Loki queries, Prometheus metrics, Grafana
  dashboards
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions
- [Command Reference](docs/command-reference.md) - Complete command
  documentation

**Project Documentation:**

- [README.md](README.md) - Project overview, features, quick start
- [TODO.md](TODO.md) - Planned improvements and pending tasks
- [docs/database-services.md](docs/database-services.md) - PostgreSQL and
  pgAdmin setup
- [docs/monitoring-dashboards.md](docs/monitoring-dashboards.md) - Dashboard
  details
- [docs/service-module-template.md](docs/service-module-template.md) - Service
  development templates
- [docs/documentation-standards.md](docs/documentation-standards.md) -
  Documentation guidelines and standards

**External Resources:**

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [NixOS Options Search](https://search.nixos.org/options)
- [Nix Package Search](https://search.nixos.org/packages)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- All development is done on NixOS. You can run missing commands using the command `nix run`.
- When merging pull requests, use rebase rather than squash to preserve git history.