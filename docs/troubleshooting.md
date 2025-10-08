# Troubleshooting Guide

Common issues and solutions for Nilfheim NixOS/Darwin configuration.

## Development and Build Issues

| Issue | Solution |
|-------|----------|
| Permission errors | Enter development shell: `nix develop` |
| Build failures | Update flake inputs: `nix flake update` |
| Linting errors | Run `just lint` and fix all warnings |
| Flake check failures | Run `just check` and resolve errors |
| Cross-compilation errors | Use `--build-host` for remote deployments |
| Module import errors | Verify file paths and module structure |
| Service conflicts | Check port assignments in `lib/constants.nix` |

## System Configuration Issues

| Issue | Solution |
|-------|----------|
| Secret access denied | Verify agenix keys configuration |
| Hardware detection issues | Update hardware-configuration.nix |
| Platform mismatch | Use correct rebuild command for your OS |
| ZFS pool not mounting | Check `boot.zfs.extraPools` configuration |
| Impermanence issues | Verify `/persist` paths in configuration |

## Service and Networking Issues

| Issue | Solution |
|-------|----------|
| Service not starting | Check logs: `journalctl -u service-name.service` |
| Port already in use | Verify port in `lib/constants.nix`, check conflicts |
| Nginx proxy not working | Verify `proxyWebsockets = true` if needed |
| Tailscale connectivity | Check `systemctl status tailscaled`, verify auth |
| NFS mount failing | Verify server is running, check firewall rules |
| Samba access denied | Check user/group permissions, verify `tank` group |

## Monitoring and Logging Issues

| Issue | Solution |
|-------|----------|
| Stream limit exceeded | Check cardinality, reduce labels |
| Timestamp errors | Disable timestamp parsing, use ingestion time |
| No backup logs | Verify systemd journal collection |
| High memory usage | Adjust retention period, stream limits |
| Missing application logs | Check file permissions, service user groups |
| Gaps in metrics | Check scrape_interval and Prometheus target health |
| Dashboard not loading | Verify Grafana provisioning, check datasource config |

## Backup Issues

| Issue | Solution |
|-------|----------|
| Repository locked | Run `restic unlock` |
| Backup service failing | Check logs: `journalctl -u restic-backups-system.service` |
| Out of disk space | Check repository: `restic stats`, run `restic prune` |
| Slow backups | Check for large files, exclude cache directories |
| Permission errors | Verify service user has read access to backup paths |
| Repository corruption | Run `restic rebuild-index` and `restic check` |

## Database Issues

| Issue | Solution |
|-------|----------|
| PostgreSQL not starting | Check logs: `journalctl -u postgresql.service` |
| Connection refused | Verify port 5432, check firewall for tailscale0 |
| Database user denied | Verify initialScript ran, check pg_hba.conf |
| pgAdmin login failed | Check initialPasswordFile, verify config |
| High query latency | Check connection pool, analyze queries |

## Container Issues

| Issue | Solution |
|-------|----------|
| Docker container not starting | Check logs: `docker logs container-name` |
| Container health check failing | Verify port accessibility, check service config |
| Volume mount errors | Verify paths exist, check permissions |
| Network connectivity issues | Check docker network: `docker network inspect` |
| High resource usage | Check cAdvisor metrics, adjust resource limits |

## Security Issues

| Issue | Solution |
|-------|----------|
| SSH key authentication failing | Verify `~/.ssh/authorized_keys`, check permissions |
| Sudo requires password | Expected behavior, use correct password |
| Fail2ban blocking legitimate IPs | Check ban list: `fail2ban-client status`, unban IP |
| Service not accessible remotely | Check firewall rules for interface (tailscale0) |
| Certificate errors | Verify Cloudflare tunnel config, check DNS |

## Debug Commands

### System Information

```bash
# Check system status
systemctl status

# View failed services
systemctl --failed

# Check boot messages
journalctl -b

# View system logs (last 50 lines)
journalctl -n 50

# Check disk usage
df -h

# Check ZFS pool status
zpool status

# Check memory usage
free -h
```

### Service Debugging

```bash
# Check service status
systemctl status service-name.service

# View service logs
journalctl -u service-name.service -f

# View service configuration
systemctl cat service-name.service

# Restart service
systemctl restart service-name.service

# Check service dependencies
systemctl list-dependencies service-name.service
```

### Network Debugging

```bash
# Check listening ports
ss -tulpn

# Check firewall rules
nft list ruleset

# Test port connectivity
nc -zv hostname port

# Check DNS resolution
dig example.com @127.0.0.1

# Check Tailscale status
tailscale status

# View Tailscale IPs
tailscale ip -4
```

### Build Debugging

```bash
# Check flake evaluation (current system)
nix flake check --systems "$(nix eval --impure --raw --expr 'builtins.currentSystem')"

# Show build logs
nix log .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Dry run build
sudo nixos-rebuild dry-run --flake .#<hostname>

# Build without switching
sudo nixos-rebuild build --flake .#<hostname>

# Quick syntax check
nix eval .#nixosConfigurations.<hostname>.config.system.build.toplevel --dry-run
```

### Container Debugging

```bash
# List running containers
docker ps

# View container logs
docker logs container-name

# Inspect container
docker inspect container-name

# Execute command in container
docker exec -it container-name /bin/bash

# View container stats
docker stats

# Check container health
docker inspect --format='{{.State.Health.Status}}' container-name
```

## Performance Tips

### Build Performance

```bash
# Faster flake checks (current system only)
nix flake check --systems "$(nix eval --impure --raw --expr 'builtins.currentSystem')"

# Parallel builds
nixos-rebuild switch --flake .#<hostname> --builders 'ssh://build-host x86_64-linux'

# Local development with build caching
nixos-rebuild build-vm --flake .#<hostname> --option builders ''

# Use binary cache
nix build --option substituters "https://cache.nixos.org"
```

### Query Performance

```bash
# Optimize Loki queries
- Use label filters first: {job="..."} before line filters
- Limit time ranges to reduce query load
- Avoid regex when possible, use literal matches

# Optimize Prometheus queries
- Use recording rules for expensive queries
- Reduce scrape_interval for less critical services
- Add proper label filters to limit scope
```

### Service Performance

```bash
# Reduce systemd service startup time
systemd-analyze blame

# Check service startup time
systemd-analyze critical-chain service-name.service

# Profile system boot
systemd-analyze plot > boot.svg

# Check slow services
systemd-analyze time
```

## Advanced Troubleshooting

### Flake Evaluation Issues

```bash
# Check flake syntax
nix flake check --show-trace

# Evaluate specific output
nix eval .#nixosConfigurations.<hostname>.config --show-trace

# Show flake structure
nix flake show

# Update specific input
nix flake lock --update-input input-name

# Check for infinite recursion
nix eval --show-trace .#nixosConfigurations.<hostname>.config 2>&1 | grep -A5 "infinite recursion"
```

### Module Debugging

```bash
# Check if module is loaded
nix eval .#nixosConfigurations.<hostname>.config.system.build.toplevel.outPath

# Trace module evaluation
nix-instantiate --eval --strict --show-trace -E '(import <nixpkgs/nixos> { configuration = ./configuration.nix; }).config'

# Check option values
nixos-option services.nginx.enable

# Show all options for a service
nixos-option services.nginx
```

### Nix Store Issues

```bash
# Check store integrity
nix-store --verify --check-contents

# Repair store
nix-store --repair-path /nix/store/path

# Optimize store
nix-store --optimise

# Garbage collection
nix-collect-garbage -d

# Clean old generations (keep last 5)
nix-collect-garbage --delete-older-than 5d
```

### Secret Management Issues

```bash
# List secrets
agenix -l

# Rekey all secrets
agenix -r

# Edit secret
agenix -e secrets/secret-name.age

# Verify secret can be decrypted
age -d -i ~/.ssh/id_ed25519 secrets/secret-name.age

# Check secret permissions
ls -la secrets/
```

## Getting Help

### Check Documentation

- **Development**: See CLAUDE.md for workflow
- **Architecture**: See CLAUDE.md Architecture Overview
- **Backups**: See [docs/backup-operations.md](backup-operations.md)
- **Monitoring**: See [docs/monitoring.md](monitoring.md)
- **Commands**: See [docs/command-reference.md](command-reference.md)

### Useful Resources

- **NixOS Manual**: https://nixos.org/manual/nixos/stable/
- **NixOS Options**: https://search.nixos.org/options
- **Nix Package Search**: https://search.nixos.org/packages
- **Home Manager**: https://nix-community.github.io/home-manager/

### Diagnostic Report

When reporting issues, provide:

```bash
# System information
nixos-version  # or darwin-rebuild --version
uname -a

# Flake info
nix flake metadata

# Failed service logs
journalctl -u service-name.service --since "1 hour ago"

# Recent system logs
journalctl --since "1 hour ago" | grep -i error

# Build error with trace
nix build --show-trace .#nixosConfigurations.<hostname>.config.system.build.toplevel 2>&1
```
