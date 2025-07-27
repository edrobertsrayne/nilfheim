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

# Format and check Nix flake
check:
    nix fmt . && nix flake check
