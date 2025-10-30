_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          telescope = {
            enable = true;
          };
          binds = {
            whichKey = {
              enable = true;
              register = {
                "<leader>f" = "+Find/Search";
                "<leader>b" = "+Buffers";
                "<leader>c" = "+Code/LSP";
                "<leader>g" = "+Git";
                "<leader>w" = "+Window";
                "<leader>u" = "+UI/Toggle";
                "<leader>s" = "+Search";
                "<leader><tab>" = "+Tabs";
              };
            };
            cheatsheet.enable = true;
          };
        };
      };
    };
  };
}
