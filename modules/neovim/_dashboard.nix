_: {
  flake.modules.generic.neovim = {
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
