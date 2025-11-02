_: {
  flake.modules.generic.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          telescope = {
            enable = true;
          };

          maps = {
            normal = {
              # === Telescope (Find/Search) ===
              "<leader><leader>" = {
                action = "<cmd>Telescope find_files<CR>";
                desc = "Find files";
              };
              "<leader>ff" = {
                action = "<cmd>Telescope find_files<CR>";
                desc = "Find files";
              };
              "<leader>/" = {
                action = "<cmd>Telescope live_grep<CR>";
                desc = "Find text (grep)";
              };
              "<leader>fg" = {
                action = "<cmd>Telescope live_grep<CR>";
                desc = "Find text (grep)";
              };
              "<leader>fb" = {
                action = "<cmd>Telescope buffers<CR>";
                desc = "Find buffers";
              };
              "<leader>," = {
                action = "<cmd>Telescope buffers<CR>";
                desc = "Find buffers";
              };
              "<leader>fr" = {
                action = "<cmd>Telescope oldfiles<CR>";
                desc = "Find recent files";
              };
              "<leader>fs" = {
                action = "<cmd>Telescope lsp_document_symbols<CR>";
                desc = "Find symbols";
              };
              "<leader>:" = {
                action = "<cmd>Telescope command_history<CR>";
                desc = "Command history";
              };
            };
          };
        };
      };
    };
  };
}
