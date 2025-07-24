# Nilfheim - NixOS/Darwin Configuration

**See README.md for project overview and TODO.md for pending improvements.**

## Essential Commands

### Development Environment

```bash
# Enter development shell (includes claude-code, gh, git, alejandra)
nix develop

# Format all nix files - ALWAYS run before committing
nix fmt
```

### System Management

#### NixOS (Linux systems only)

```bash
# Rebuild NixOS system (run on target host)
sudo nixos-rebuild switch --flake .#<hostname>

# Rebuild remote NixOS system (build on remote host to avoid cross-compilation)
nixos-rebuild switch --flake .#<hostname> --target-host <hostname> --build-host <hostname> --sudo

# Example: Deploy to thor host
nixos-rebuild switch --flake .#thor --target-host thor --build-host thor --sudo

# Build VM for testing (Linux only)
nixos-rebuild build-vm --flake .#<hostname>

# Dry run rebuild
sudo nixos-rebuild dry-run --flake .#<hostname>

# Dry run for remote host
nixos-rebuild dry-run --flake .#<hostname> --target-host <hostname> --build-host <hostname> --sudo
```

#### Darwin (macOS systems only)

```bash
# Rebuild Darwin system
darwin-rebuild switch --flake .#<hostname>

# Check Darwin configuration
darwin-rebuild check --flake .#<hostname>
```

#### Universal Commands

```bash
# Update flake inputs
nix flake update

# Show system configuration
nix flake show
```

### Secrets Management (agenix)

```bash
# Edit secrets (Linux only)
agenix -e secrets/<secret-name>.age

# Rekey all secrets
agenix -r
```

## Development Workflow

1. **Create feature branch**: `git checkout -b feat/feature-name` or `git checkout -b fix/issue-name`
2. Make changes to relevant modules in `modules/` or host configs in `hosts/`
3. **Always format code before committing**: `nix fmt`
4. **Test configuration**:
   - **NixOS (Linux)**: Build VM for testing:
     `nixos-rebuild build-vm --flake .#<hostname>`
   - **Darwin (macOS)**: Check configuration:
     `darwin-rebuild check --flake .#<hostname>`
5. **Test in VM (NixOS only)**: Run the generated VM script to test changes in
   isolation
6. **Before each commit**:
   - **Always run**: `nix fmt .` to format all files
   - **Check flake validity**:
     - **NixOS (Linux)**: `nix flake check --systems "$(nix eval --impure --raw --expr 'builtins.currentSystem')"`
     - **Darwin (macOS)**: `nix flake check`
7. **Commit small changes frequently** using conventional commits format: `type(scope): description`
   - Examples: `feat(homelab): add navidrome music server`, `fix(security): enable sudo password requirement`, `refactor(services): create service abstraction library`
8. Apply changes:
   - **NixOS (local)**: `sudo nixos-rebuild switch --flake .#<hostname>`
   - **NixOS (remote)**: `nixos-rebuild switch --flake .#<hostname> --target-host <hostname> --build-host <hostname> --sudo`
   - **Darwin**: `darwin-rebuild switch --flake .#<hostname>`
9. **Rebase development branch against main before creating PRs**: `git rebase main`

### Pre-commit Checklist

- [ ] **REQUIRED**: Run `nix fmt .` to format all Nix files
- [ ] **REQUIRED**: Check flake validity:
  - **NixOS (Linux)**: `nix flake check --systems "$(nix eval --impure --raw --expr 'builtins.currentSystem')"`
  - **Darwin (macOS)**: `nix flake check`
- [ ] Verify no formatting changes remain: `git diff`
- [ ] Test configuration builds successfully
- [ ] **For NixOS changes**: Test in VM using `nixos-rebuild build-vm`
- [ ] **For Darwin changes**: Verify with `darwin-rebuild check`
- [ ] **Before PR**: Rebase dev branch against main: `git rebase main`
- [ ] **Commit format**: Use conventional commits `type(scope): description`

### Package Management

All systems run Nix, so missing packages can be run without installation:

```bash
# Run missing commands using nix
nix run nixpkgs#jq          # Run jq without installing
nix run nixpkgs#curl        # Run curl
nix run nixpkgs#tree        # Run tree
nix run nixpkgs#htop        # Run htop

# Example: Parse JSON from a command
curl -s http://api.example.com | nix run nixpkgs#jq -- '.data'
```

## Troubleshooting

### Common Issues

- **Permission errors**: Ensure you're in the development shell (`nix develop`)
- **Build failures**: Check flake inputs are up to date (`nix flake update`)
- **Secret access**: Verify agenix keys are properly configured
- **Hardware issues**: Check hardware-configuration.nix is up to date
- **Platform mismatch**: Remember `nixos-rebuild` only works on Linux,
  `darwin-rebuild` only on macOS
- **Cross-compilation issues**: Always use `--build-host <hostname>` when deploying to remote hosts to ensure builds happen on the target architecture

### Debug Commands

```bash
# Check flake evaluation (specify current architecture to avoid cross-platform build errors)
nix flake check --systems "$(nix eval --impure --raw --expr 'builtins.currentSystem')"

# Show build logs for nixos
nix log .#nixosConfigurations.<hostname>.config.system.build.toplevel
```

## Service Configuration Guidelines

### Nginx Proxy Services

When adding new nginx proxy services, follow these guidelines:

**✅ DO:**
```nix
services.nginx.virtualHosts."${cfg.url}" = {
  locations."/" = {
    proxyPass = "http://127.0.0.1:${toString port}";
    proxyWebsockets = true;  # Enables WebSocket support
  };
};
```

**❌ DON'T:**
- Add custom proxy headers in `extraConfig` - NixOS recommended proxy settings handle these automatically
- Duplicate WebSocket headers (`proxy_set_header Upgrade` / `proxy_set_header Connection`)
- Override timeout/buffer settings unless absolutely necessary for the specific service

**Why:** NixOS includes recommended proxy settings in `modules/nixos/services/network/nginx.nix` that automatically provide:
- Proper proxy headers (Host, X-Forwarded-*, X-Real-IP, etc.)
- WebSocket upgrade mapping and headers
- Optimal timeouts and buffer settings
- Security headers

Custom `extraConfig` can conflict with these built-in settings and cause 400 Bad Request errors.

**Special Cases:**
- **Proxmox VE**: Requires `https://` proxy and SSL verification bypass
- **Static assets**: May need additional location blocks for CSS/JS/images
- **Service-specific headers**: Only add if genuinely required by the application

### ZFS Snapshots

ZFS snapshots are managed using the built-in NixOS `services.zfs.autoSnapshot` service for systems with ZFS pools.

**Configuration:**
```nix
services.zfs.autoSnapshot = {
  enable = true;
  # Retention policies (defaults shown)
  frequent = 4;   # 15-minute snapshots
  hourly = 24;    # Hourly snapshots
  daily = 7;      # Daily snapshots
  weekly = 4;     # Weekly snapshots
  monthly = 12;   # Monthly snapshots
};
```

**Requirements:**
- ZFS datasets must have `com.sun:auto-snapshot=true` property set (configured in disko)
- Only applies to NixOS systems with ZFS pools

**❌ Never apply ZFS configurations to:**
- Darwin (macOS) systems  
- Systems without ZFS pools
- Systems where ZFS is not the primary filesystem

