_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          dashboard.alpha.enable = true;
          visuals = {
            nvim-web-devicons.enable = true;
            fidget-nvim.enable = true;
            highlight-undo.enable = true;
            indent-blankline.enable = true;
          };
        };
      };
    };
  };
}
