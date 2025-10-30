_: {
  flake.modules.homeManager.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          statusline = {
            lualine = {
              enable = true;
            };
          };
          tabline = {
            nvimBufferline = {
              enable = true;
            };
          };
          ui = {
            borders.enable = true;
            noice.enable = true;
            colorizer.enable = true;
            breadcrumbs = {
              enable = true;
              navbuddy.enable = true;
            };
          };
        };
      };
    };
  };
}
