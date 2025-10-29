_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          languages = {
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
          };
        };
      };
    };
  };
}
