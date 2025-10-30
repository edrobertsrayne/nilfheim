_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;
            nix = {
              enable = true;
              lsp = {
                enable = true;
              };
              format = {
                enable = true;
                type = "alejandra";
              };
              extraDiagnostics = {
                enable = true;
                types = ["statix" "deadnix"];
              };
            };
            markdown.enable = true;
            python.enable = true;
          };
        };
      };
    };
  };
}
