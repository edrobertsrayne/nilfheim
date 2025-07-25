{
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      formatOnSave = true;
      lightbulb.enable = true;
      trouble = {
        enable = true;
        mappings = {
          workspaceDiagnostics = "<leader>xX";
          documentDiagnostics = "<leader>xx";
          locList = "<leader>xL";
          quickfix = "<leader>xQ";
        };
      };
      # lspSignature.enable = true;
    };
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      bash.enable = true;
      lua.enable = true;
      nix = {
        enable = true;
      };
      markdown.enable = true;
      python.enable = true;
      yaml.enable = true;
    };
    # diagnostics = {
    #   enable = true;
    #   nvim-lint = {
    #     enable = true;
    #     linters_by_ft = {
    #       javascript = ["eslint_d"];
    #       typescript = ["eslint_d"];
    #       python = ["ruff"];
    #       lua = ["luacheck"];
    #     };
    #   };
    # };
    # formatter = {
    #   conform-nvim = {
    #     enable = true;
    #     setupOpts = {
    #       formatters_by_ft = {
    #         lua = ["stylua"];
    #         nix = ["alejandra"];
    #         javascript = ["prettier"];
    #         typescript = ["prettier"];
    #         python = ["ruff_format"];
    #         markdown = ["prettier"];
    #         yaml = ["prettier"];
    #         json = ["prettier"];
    #       };
    #       format_on_save = {
    #         lsp_format = "fallback";
    #         timeout_ms = 500;
    #       };
    #     };
    #   };
    # };
  };
}
