_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          # ===== LSP (Language Server Protocol) =====
          # LSP provides intelligent code features like autocomplete, go-to-definition,
          # error checking, and refactoring across multiple languages
          lsp = {
            enable = true;
            formatOnSave = true; # Automatically format files when saving
            lightbulb.enable = true; # Show lightbulb icon when code actions are available
            lspkind.enable = true; # Add icons to completion menu showing item type (function, variable, etc.)
          };
        };
      };
    };
  };
}
