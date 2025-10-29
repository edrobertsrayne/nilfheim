_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          # ===== TREESITTER =====
          # Treesitter provides advanced syntax highlighting and code understanding
          # by parsing code into an Abstract Syntax Tree (AST)
          treesitter = {
            enable = true;
            fold = true; # Enable code folding based on treesitter's understanding
          };
        };
      };
    };
  };
}
