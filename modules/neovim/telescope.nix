_: {
  flake.modules.homeManager.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          telescope = {
            enable = false;
          };
        };
      };
    };
  };
}
