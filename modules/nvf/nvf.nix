{inputs, ...}: {
  flake.modules.homeManager.nvf = {
    # Import the upstream nvf home-manager module
    imports = [inputs.nvf.homeManagerModules.default];

    # Disable stylix theming for nvf - we'll use nvf's own theme system
    stylix.targets.nvf.enable = false;

    # All nvf configuration is now modular and distributed across aspect files:
    # - core.nix: Basic setup, aliases, theme
    # - lsp.nix: Language Server Protocol settings
    # - languages.nix: Language-specific configuration (Nix, etc.)
    # - treesitter.nix: Syntax highlighting
    # - completion.nix: Autocomplete and snippets
    # - navigation.nix: Telescope and which-key
    # - ui.nix: Statusline, tabline, UI enhancements
    # - git.nix: Git integration
    # - utilities.nix: Autopairs, comments, surround, motion
    # - options.nix: Editor settings
    # - keymaps.nix: All keybindings
  };
}
