_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.navic = {
      enable = true;
      settings = {
        lsp.auto_attach = true;
        highlight = true;
      };
    };
  };
}
