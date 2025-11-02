_: {
  flake.modules.home.neovim = {
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
