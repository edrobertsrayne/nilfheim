_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          filetree.neo-tree.enable = true;
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
          terminal = {
            toggleterm = {
              enable = true;
              lazygit.enable = true;
            };
          };
        };
      };
    };
  };
}
