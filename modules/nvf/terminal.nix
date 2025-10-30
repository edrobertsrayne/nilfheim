_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          terminal = {
            toggleterm = {
              enable = true;
              lazygit.enable = true;
            };
          };

          maps = {
            normal = {
              "<C-_>" = {
                action = "<cmd>ToggleTerm<CR>";
                desc = "Toggle terminal";
              };
            };

            terminal = {
              "<C-_>" = {
                action = "<cmd>ToggleTerm<CR>";
                desc = "Toggle terminal";
              };
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
