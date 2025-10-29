_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          telescope = {
            enable = true;
          };
          binds = {
            whichKey = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
