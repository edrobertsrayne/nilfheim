_: {
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim = {
      mini = {
        ai.enable = true;
        surround.enable = true;
        icons.enable = true;
        pairs.enable = true;
        comment.enable = true;
      };
    };
  };
}
