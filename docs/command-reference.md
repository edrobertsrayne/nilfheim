# Command Reference

Complete command reference for Nilfheim NixOS/Darwin configuration.

## Development Shell

```bash
# Enter development environment (provides: claude-code, gh, git, alejandra, just)
nix develop

# Run package without installing
nix run nixpkgs#package-name

# Examples
nix run nixpkgs#jq
nix run nixpkgs#curl
nix run nixpkgs#htop

# Use in pipes
curl -s http://api.example.com | nix run nixpkgs#jq -- '.data'
```

## Quick Commands (Just)

```bash
# List all available commands
just --list

# Development workflow
just lint                # Format + lint (statix + deadnix)
just check               # Full validation (lint + flake check)

# Deployment
just freya               # Deploy to freya (local NixOS)
just odin                # Deploy to odin (local macOS)
just thor                # Deploy to thor (remote)
just loki                # Deploy to loki (remote)

# CI/CD testing
just ci-list             # List available CI workflows
just ci-quality-dry      # Quick validation (dry run)
just ci-validate         # Full CI validation
just ci-quality          # Run quality checks
just ci-format           # Run formatting checks
just ci-pr               # Simulate pull request
```

## NixOS Commands

### Local Rebuild

```bash
# Switch to new configuration
sudo nixos-rebuild switch --flake .#<hostname>

# Build VM for testing
nixos-rebuild build-vm --flake .#<hostname>

# Build without switching
sudo nixos-rebuild build --flake .#<hostname>

# Dry run (show changes)
sudo nixos-rebuild dry-run --flake .#<hostname>

# Test configuration (reboot required to finalize)
sudo nixos-rebuild test --flake .#<hostname>
```

### Remote Rebuild

```bash
# Deploy to remote host (builds remotely to avoid cross-compilation)
nixos-rebuild switch --flake .#<hostname> \
  --target-host <hostname> \
  --build-host <hostname> \
  --sudo

# Example: Deploy to thor
nixos-rebuild switch --flake .#thor \
  --target-host thor \
  --build-host thor \
  --sudo

# Dry run remote deployment
nixos-rebuild dry-run --flake .#<hostname> \
  --target-host <hostname> \
  --build-host <hostname> \
  --sudo
```

## Darwin Commands

```bash
# Rebuild macOS system
darwin-rebuild switch --flake .#<hostname>

# Check configuration
darwin-rebuild check --flake .#<hostname>

# Build without switching
darwin-rebuild build --flake .#<hostname>
```

## Nix Flake Commands

```bash
# Show flake outputs
nix flake show

# Check flake
nix flake check

# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input <input-name>

# Show flake metadata
nix flake metadata

# Check syntax (with trace)
nix flake check --show-trace

# Check current system only
nix flake check --systems "$(nix eval --impure --raw --expr 'builtins.currentSystem')"
```

## Code Quality Commands

```bash
# Format all Nix files
nix fmt .

# Lint for code quality issues
statix check .

# Detect dead/unused code
deadnix -l .

# Fix issues automatically (statix)
statix fix .

# Remove dead code (deadnix)
deadnix -e .
```

## System Management

### Service Management

```bash
# Check service status
systemctl status <service-name>

# Start/stop/restart service
systemctl start <service-name>
systemctl stop <service-name>
systemctl restart <service-name>

# Enable/disable service
systemctl enable <service-name>
systemctl disable <service-name>

# View service logs
journalctl -u <service-name>

# Follow service logs
journalctl -u <service-name> -f

# View recent logs
journalctl -u <service-name> --since "1 hour ago"
```

### System Logs

```bash
# View system log
journalctl

# View boot messages
journalctl -b

# Follow live logs
journalctl -f

# Show errors only
journalctl -p err

# View logs for specific unit
journalctl -u nginx.service

# Show logs since specific time
journalctl --since "2023-10-01"
journalctl --since "1 hour ago"
journalctl --since yesterday
```

### Generation Management

```bash
# List system generations
nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Delete old generations (free space)
nix-collect-garbage -d

# Delete generations older than 30 days
nix-collect-garbage --delete-older-than 30d

# Optimize nix store
nix-store --optimise
```

## Secrets Management (agenix)

```bash
# Edit secret
agenix -e secrets/<secret-name>.age

# Create new secret
agenix -e secrets/<new-secret>.age

# Rekey all secrets (after adding new SSH key)
agenix -r

# List secrets
ls secrets/

# Manually decrypt (for verification)
age -d -i ~/.ssh/id_ed25519 secrets/<secret-name>.age
```

## Backup Commands

See [docs/backup-operations.md](backup-operations.md) for complete backup documentation.

```bash
# Check backup service status
systemctl status restic-backups-system.service

# View backup logs
journalctl -u restic-backups-system.service -f

# Trigger manual backup
systemctl start restic-backups-system.service

# Configure restic environment
export RESTIC_REPOSITORY=/mnt/backup/$(hostname)/restic
export RESTIC_PASSWORD_FILE=/etc/restic/password

# List snapshots
restic snapshots

# Show repository stats
restic stats

# Check repository integrity
restic check

# Restore files
restic restore latest --target /tmp/restore --include /path/to/file
```

## Monitoring Commands

See [docs/monitoring.md](monitoring.md) for complete monitoring documentation.

```bash
# Check monitoring services
systemctl status grafana.service
systemctl status prometheus.service
systemctl status loki.service
systemctl status promtail.service

# Check service health
curl -s localhost:3000/api/health        # Grafana
curl -s localhost:9090/-/healthy          # Prometheus
curl -s localhost:3100/ready              # Loki

# Query Loki
curl -G localhost:3100/loki/api/v1/query \
  --data-urlencode 'query={job="systemd-journal"}' \
  --data-urlencode 'limit=10'

# List Loki labels
curl -s localhost:3100/loki/api/v1/labels

# Query Prometheus
curl -s localhost:9090/api/v1/query?query=up

# List Prometheus targets
curl -s localhost:9090/api/v1/targets
```

## Network Commands

### Tailscale

```bash
# Check status
tailscale status

# Show IP addresses
tailscale ip -4
tailscale ip -6

# Connect/disconnect
tailscale up
tailscale down

# Show network info
tailscale netcheck

# Ping peer
tailscale ping <hostname>
```

### SSH

```bash
# Connect to host
ssh <hostname>

# Connect with specific key
ssh -i ~/.ssh/id_ed25519 <hostname>

# Copy files via SCP
scp file.txt <hostname>:/path/to/destination

# Copy directory recursively
scp -r directory/ <hostname>:/path/to/destination

# Sync files via rsync
rsync -avz --progress source/ <hostname>:/path/to/destination/
```

### Network Troubleshooting

```bash
# Check listening ports
ss -tulpn

# Check port connectivity
nc -zv hostname port

# Check DNS resolution
dig example.com
nslookup example.com

# Test with specific DNS server
dig @127.0.0.1 example.com

# Show routing table
ip route show

# Check firewall rules
nft list ruleset
```

## Container Commands

```bash
# List containers
docker ps
docker ps -a

# View container logs
docker logs <container-name>
docker logs -f <container-name>

# Execute command in container
docker exec -it <container-name> /bin/bash
docker exec <container-name> command

# Inspect container
docker inspect <container-name>

# View container stats
docker stats

# Stop/start container
docker stop <container-name>
docker start <container-name>

# Remove container
docker rm <container-name>

# View images
docker images

# Remove unused containers/images
docker system prune
```

## ZFS Commands

```bash
# List pools
zpool list

# Show pool status
zpool status

# List datasets
zfs list

# Show dataset properties
zfs get all <dataset>

# Create snapshot
zfs snapshot <pool>/<dataset>@<snapshot-name>

# List snapshots
zfs list -t snapshot

# Rollback to snapshot
zfs rollback <pool>/<dataset>@<snapshot-name>

# Delete snapshot
zfs destroy <pool>/<dataset>@<snapshot-name>

# Check ZFS health
zpool status -x
```

## Database Commands

### PostgreSQL

```bash
# Connect to database
psql -U postgres

# List databases
psql -U postgres -l

# Connect to specific database
psql -U postgres -d database_name

# Execute SQL file
psql -U postgres -d database_name -f script.sql

# Dump database
pg_dump -U postgres database_name > backup.sql

# Restore database
psql -U postgres -d database_name < backup.sql

# Check PostgreSQL status
systemctl status postgresql.service
```

### pgAdmin

Access via web interface: `https://pgadmin.${domain}`

## Git Commands

```bash
# Create feature branch
git checkout -b feat/feature-name
git checkout -b fix/issue-name

# Stage changes
git add .
git add file.txt

# Commit with conventional format
git commit -m "feat(scope): description"
git commit -m "fix(scope): description"
git commit -m "refactor(scope): description"

# Push branch
git push origin branch-name
git push -u origin branch-name

# Rebase on main
git rebase main

# Interactive rebase
git rebase -i HEAD~3

# View status
git status

# View diff
git diff
git diff --staged
```

## GitHub CLI

```bash
# Create pull request
gh pr create --title "Title" --body "Description"

# View pull request
gh pr view 123

# List pull requests
gh pr list

# Checkout pull request
gh pr checkout 123

# View issue
gh issue view 123

# Create issue
gh issue create --title "Title" --body "Description"
```

## Build Optimization

```bash
# Build with substituters
nix build --option substituters "https://cache.nixos.org"

# Build with max jobs
nix build --max-jobs 8

# Build with verbose output
nix build --verbose

# Show build trace
nix build --show-trace

# Build specific output
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Evaluate without building
nix eval .#nixosConfigurations.<hostname>.config.system.build.toplevel --dry-run
```

## Debugging Commands

```bash
# Show build logs
nix log /nix/store/path

# Verify store integrity
nix-store --verify --check-contents

# Repair path
nix-store --repair-path /nix/store/path

# Show dependencies
nix-store --query --references /nix/store/path

# Show reverse dependencies
nix-store --query --referrers /nix/store/path

# Show derivation
nix show-derivation /nix/store/path

# Evaluate with trace
nix-instantiate --eval --strict --show-trace -E 'expression'
```

## Performance Analysis

```bash
# Analyze boot time
systemd-analyze

# Show service startup times
systemd-analyze blame

# Show critical chain
systemd-analyze critical-chain

# Generate boot plot
systemd-analyze plot > boot.svg

# Check system time
systemd-analyze time
```
