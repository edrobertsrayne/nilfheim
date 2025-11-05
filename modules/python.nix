_: {
  flake.modules.homeManager.python = {
    programs = {
      uv.enable = true;
      ruff = {
        enable = true;
        settings = {
          line-length = 100;
        };
      };
      nvf.settings.vim = {
        languages.python = {
          enable = true;
          format = {
            enable = true;
            type = "ruff";
          };
          lsp.enable = true;
          dap.enable = true;
        };
        withPython3 = true;
      };
    };
  };
}
