_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          autocomplete = {
            nvim-cmp = {
              enable = true;
            };
          };

          snippets = {
            luasnip.enable = true;
          };
        };
      };
    };
  };
}
