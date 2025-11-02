{inputs, ...}: {
  # NOTE: This file will be removed in Phase 10
  # desktop.nix now handles the nixos.desktop aggregation
  # Keeping only the generic.desktop aggregator for now

  flake.modules.generic.desktop.imports = with inputs.self.modules.generic; [
    # Desktop GUI applications (cross-platform)
    # TODO: Should include firefox, alacritty, etc. instead of utilities/neovim
    # For now, empty to avoid duplicates - apps will be added via individual modules
  ];
}
