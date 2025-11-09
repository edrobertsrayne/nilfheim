_: {
  flake.modules.homeManager.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          terminal = {
            toggleterm = {
              enable = false;
            };
          };

          maps = {
            terminal = {
              "<Esc><Esc>" = {
                action = "<C-\\><C-n>";
                desc = "Exit terminal mode";
              };
            };
          };
        };
      };
    };
  };
}
