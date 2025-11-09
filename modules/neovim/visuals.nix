_: {
  flake.modules.homeManager.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          visuals = {
            nvim-web-devicons.enable = true;
            highlight-undo.enable = true;
            rainbow-delimiters.enable = true;
          };
        };
      };
    };
  };
}
