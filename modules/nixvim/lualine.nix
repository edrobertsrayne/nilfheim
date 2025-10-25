_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.lualine = {
      enable = true;
      settings.options = {
        globalstatus = true;
        icons_enabled = true;
      };
    };
  };
}
