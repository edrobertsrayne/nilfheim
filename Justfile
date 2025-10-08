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
    NIX_CHECK_CURRENT_SYSTEM_ONLY=1 nix flake check --impure
