_: {
  flake.modules.generic.neovim = {
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
