_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = true;
            lspkind.enable = true;
          };
        };
      };
    };
  };
}
