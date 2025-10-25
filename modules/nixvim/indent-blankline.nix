_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.indent-blankline = {
      enable = true;
    };
  };
}
