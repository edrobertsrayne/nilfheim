_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          autocomplete.blink-cmp.enable = true;
          snippets.luasnip.enable = true;
        };
      };
    };
  };
}
