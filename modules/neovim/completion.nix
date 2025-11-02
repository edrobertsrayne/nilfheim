_: {
  flake.modules.generic.neovim = {
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
