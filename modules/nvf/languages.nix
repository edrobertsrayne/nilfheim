_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          # ===== LANGUAGE SUPPORT =====
          # nvf provides integrated language modules that bundle LSP, treesitter,
          # formatting, and diagnostics for specific languages
          languages = {
            nix = {
              enable = true;
              lsp = {
                enable = true; # Enable nixd LSP server for Nix intelligence
              };
              format = {
                enable = true;
                type = "alejandra"; # Use alejandra as the Nix formatter
              };
              extraDiagnostics = {
                enable = true;
                types = ["statix" "deadnix"]; # Additional linters: statix (anti-patterns), deadnix (unused code)
              };
            };
          };
        };
      };
    };
  };
}
