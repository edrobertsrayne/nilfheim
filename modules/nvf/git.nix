_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          git = {
            enable = true;
            gitsigns = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
