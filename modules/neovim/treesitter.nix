_: {
  flake.modules.homeManager.neovim = {
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
