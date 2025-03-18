{
  programs.nvf.settings.vim = {
    lsp = {
      formatOnSave = true;
      lightbulb.enable = true;
      trouble.enable = true;
      lspSignature.enable = true;
    };
    languages = {
      enableLSP = true;
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      bash.enable = true;
      lua.enable = true;
      nix.enable = true;
      markdown.enable = true;
      python.enable = true;
      yaml.enable = true;
    };
  };
}
