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
    };
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      bash.enable = true;
      go.enable = true;
      lua.enable = true;
      nix.enable = true;
      markdown.enable = true;
      python.enable = true;
      yaml.enable = true;
    };
  };
}
