_: {
  flake.modules.home.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          treesitter = {
            enable = true;
            fold = true;
          };
        };
      };
    };
  };
}
