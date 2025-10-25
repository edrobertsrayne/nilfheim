_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.lualine = {
      enable = true;
    };
  };
}
