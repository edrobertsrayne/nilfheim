_: {
  flake.modules.homeManager.neovim = {
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
          notes.todo-comments.enable = true;
        };
      };
    };
  };
}
