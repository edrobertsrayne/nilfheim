_: {
  flake.modules.home.neovim = {
    programs.nvf.settings.vim = {
      diagnostics = {
        enable = true;
        config = {
          virtual_text = {
            severity = {
              min = "WARN";
            };
          };
          signs = true;
          underline = true;
          update_in_insert = false;
          severity_sort = true;
        };
      };
    };
  };
}
