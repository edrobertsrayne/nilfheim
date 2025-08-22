# Build and deploy 'loki' configuration
loki:
    nixos-rebuild switch --flake .#loki --target-host=root@loki --build-host=root@thor

# Build and deploy 'thor' configuration
thor:
    nixos-rebuild switch --flake .#thor --target-host=root@thor --build-host=root@thor

# Rebuild 'freya' configuration locally
freya:
    sudo nixos-rebuild switch --flake .#freya

# Rebuild 'odin' (macOS) configuration locally
odin:
    sudo darwin-rebuild switch --flake .#odin

# Run linting tools (formatting, static analysis, dead code detection)
lint:
    nix fmt .
    nix run nixpkgs#statix -- check .
    nix run nixpkgs#deadnix -- -l .

# Run full flake validation (includes lint + comprehensive flake check)
check:
    just lint
    nix flake check

# List available GitHub Actions workflows and jobs
ci-list:
    nix run nixpkgs#act -- --list

# Run code quality checks locally (statix, deadnix, formatting)
ci-quality:
    nix run nixpkgs#act -- --job quality

# Dry run quality checks (validation only)
ci-quality-dry:
    nix run nixpkgs#act -- --job quality --dryrun

# Run formatting workflow locally
ci-format:
    nix run nixpkgs#act -- --job format

# Simulate pull request event (runs all PR workflows)
ci-pr:
    nix run nixpkgs#act -- pull_request

# Simulate push event (runs all push workflows)
ci-push:
    nix run nixpkgs#act -- push

# Run flake check locally (matches GitHub Actions workflow)
ci-build:
    nix run nixpkgs#act -- --job check

# Complete local CI validation (quality + format + flake check)
ci-validate:
    nix run nixpkgs#act -- --job quality --dryrun
    nix run nixpkgs#act -- --job format --dryrun
    nix run nixpkgs#act -- --job check --dryrun
    @echo "✅ All workflows validated successfully"
