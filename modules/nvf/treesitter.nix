_: {
  flake.modules.homeManager.nvf = {
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
