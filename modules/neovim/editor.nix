_: {
  flake.modules.generic.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          autopairs = {
            nvim-autopairs.enable = true;
          };
          comments = {
            comment-nvim.enable = true;
          };
          utility = {
            surround.enable = true;
            motion = {
              hop.enable = true;
            };
          };
        };
      };
    };
  };
}
