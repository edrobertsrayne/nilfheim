_: {
  flake.modules.home.neovim = {
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
