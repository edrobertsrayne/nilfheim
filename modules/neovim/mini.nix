_: {
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim = {
      mini = {
        ai.enable = true;
        surround = {
          enable = true;
          setupOpts = {
            mappings = {
              add = "gsa";
              delete = "gsd";
              find = "gsf";
              find_left = "gsF";
              highlight = "gsh";
              replace = "gsr";
              update_n_lines = "gsn";
            };
          };
        };
        icons.enable = true;
        pairs.enable = true;
        comment.enable = true;
      };
    };
  };
}
