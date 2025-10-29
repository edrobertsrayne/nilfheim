_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          # ===== COMPLETION =====
          # Autocomplete engine that shows suggestions as you type
          autocomplete = {
            nvim-cmp = {
              enable = true; # Using nvim-cmp as the completion engine
            };
          };

          # Snippet engine for expanding code templates
          snippets = {
            luasnip.enable = true;
          };
        };
      };
    };
  };
}
