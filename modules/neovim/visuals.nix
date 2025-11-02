_: {
  flake.modules.home.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          visuals = {
            nvim-web-devicons.enable = true;
            fidget-nvim.enable = true;
            highlight-undo.enable = true;
            indent-blankline.enable = true;
            rainbow-delimiters.enable = true;
          };
        };
      };
    };
  };
}
