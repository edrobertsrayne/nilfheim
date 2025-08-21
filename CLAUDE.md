# Nilfheim - NixOS/Darwin Configuration

**See README.md for project overview and TODO.md for pending improvements.**

## Essential Commands

### Development Environment

```bash
# Enter development shell (includes claude-code, gh, git, alejandra, just)
nix develop

# See all available commands
just --list

# Format and check flake - REQUIRED before committing  
just check
```

### Manual Development Commands
```bash
# Format all nix files - REQUIRED before committing
nix fmt .
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

1. **Create feature branch**:
   - Features: `git checkout -b feat/feature-name`
   - Fixes: `git checkout -b fix/issue-name`

2. **Make changes** in `modules/` or `hosts/`

3. **Format and validate**: `just check`

4. **Run quality checks**: `just ci-quality-dry` (fast validation)

5. **Test local CI**: `just ci-validate` (comprehensive validation)

6. **Test configuration**:
   - NixOS: `nixos-rebuild build-vm --flake .#<hostname>`
   - Darwin: `darwin-rebuild check --flake .#<hostname>`

7. **Manual validation** (if needed):
   - Lint: `statix check .`
   - Dead code: `deadnix -l .`
   - Flake check: `nix flake check`

8. **Commit** using conventional format: `type(scope): description`
   - Examples:
     - `feat(homelab): add navidrome music server`
     - `fix(security): enable sudo password requirement`
     - `refactor(services): create service abstraction library`

9. **Apply changes**:
   - Quick: `just <hostname>` (freya, odin, thor, loki)
   - Manual NixOS local: `sudo nixos-rebuild switch --flake .#<hostname>`
   - Manual NixOS remote: `nixos-rebuild switch --flake .#<hostname> --target-host <hostname> --build-host <hostname> --sudo`
   - Manual Darwin: `darwin-rebuild switch --flake .#<hostname>`

10. **Before PR**: `git rebase main`

### Pre-commit Checklist

- [ ] Run `just check` (format + flake check)
- [ ] Run `just ci-quality-dry` (fast validation)
- [ ] Verify no formatting changes: `git diff`
- [ ] Test configuration builds
- [ ] Test in VM (NixOS) or check (Darwin)
- [ ] Rebase against main
- [ ] Use conventional commit format

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

| Issue             | Solution                                  |
| ----------------- | ----------------------------------------- |
| Permission errors | Enter development shell: `nix develop`    |
| Build failures    | Update flake inputs: `nix flake update`   |
| Secret access     | Verify agenix keys configuration          |
| Hardware issues   | Update hardware-configuration.nix         |
| Platform mismatch | Use correct rebuild command for your OS   |
| Cross-compilation | Use `--build-host` for remote deployments |

### Debug Commands

```bash
# Check flake evaluation (current architecture only)
nix flake check --systems "$(nix eval --impure --raw --expr 'builtins.currentSystem')"

# Show build logs
nix log .#nixosConfigurations.<hostname>.config.system.build.toplevel
```

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

- Proxmox VE: Requires `https://` proxy and SSL verification bypass
- Static assets: May need additional location blocks
- Service-specific headers: Only if required by the application

### ZFS Snapshots

**Configuration:**

```nix
services.zfs.autoSnapshot = {
  enable = true;
  frequent = 4;   # 15-minute snapshots
  hourly = 24;
  daily = 7;
  weekly = 4;
  monthly = 12;
};
```

**Requirements:**

- ZFS datasets must have `com.sun:auto-snapshot=true` property
- Only for NixOS systems with ZFS pools
- Not applicable to Darwin or non-ZFS systems
