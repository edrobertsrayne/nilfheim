_: {
  flake.modules.homeManager.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          filetree.neo-tree.enable = false;
        };
      };
    };
  };
}
