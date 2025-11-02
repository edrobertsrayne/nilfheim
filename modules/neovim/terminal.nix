_: {
  flake.modules.home.neovim = {
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
              "<C-`>" = {
                action = "<cmd>ToggleTerm<CR>";
                desc = "Toggle terminal";
              };
            };

            terminal = {
              "<C-`>" = {
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
