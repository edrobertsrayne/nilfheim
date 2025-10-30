_: {
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim.dashboard.dashboard-nvim = {
      enable = true;
      setupOpts = {
        config = {
          packages.enable = false;
        };
      };
    };
  };
}
