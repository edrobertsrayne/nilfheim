_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          maps = {
            normal = {
              "<leader>w" = {
                action = ":w<CR>";
                desc = "Save file";
              };

              # === LSP ===
              "K" = {
                action = "vim.lsp.buf.hover";
                lua = true;
                desc = "Hover documentation";
              };
              "gd" = {
                action = "vim.lsp.buf.definition";
                lua = true;
                desc = "Go to definition";
              };
              "gr" = {
                action = "vim.lsp.buf.references";
                lua = true;
                desc = "Go to references";
              };
              "<leader>ca" = {
                action = "vim.lsp.buf.code_action";
                lua = true;
                desc = "Code actions";
              };
              "<leader>cr" = {
                action = "vim.lsp.buf.rename";
                lua = true;
                desc = "Rename symbol";
              };

              # === Telescope (Find) ===
              "<leader>ff" = {
                action = "<cmd>Telescope find_files<CR>";
                desc = "Find files";
              };
              "<leader>fg" = {
                action = "<cmd>Telescope live_grep<CR>";
                desc = "Find text (grep)";
              };
              "<leader>fb" = {
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

              # === Buffer management ===
              "<leader>bd" = {
                action = ":bdelete<CR>";
                desc = "Delete buffer";
              };
              "<S-h>" = {
                action = ":bprevious<CR>";
                desc = "Previous buffer";
              };
              "<S-l>" = {
                action = ":bnext<CR>";
                desc = "Next buffer";
              };

              # === Window navigation ===
              "<C-h>" = {
                action = "<C-w>h";
                desc = "Move to left window";
              };
              "<C-j>" = {
                action = "<C-w>j";
                desc = "Move to bottom window";
              };
              "<C-k>" = {
                action = "<C-w>k";
                desc = "Move to top window";
              };
              "<C-l>" = {
                action = "<C-w>l";
                desc = "Move to right window";
              };

              # === Better n/N (center search results) ===
              "n" = {
                action = "nzzzv";
                desc = "Next search result";
              };
              "N" = {
                action = "Nzzzv";
                desc = "Previous search result";
              };
            };

            insert = {
              "jk" = {
                action = "<Esc>";
                desc = "Exit insert mode";
              };
            };

            visual = {
              # Keep selection after indent
              "<" = {
                action = "<gv";
                desc = "Indent left";
              };
              ">" = {
                action = ">gv";
                desc = "Indent right";
              };

              "J" = {
                action = ":m '>+1<CR>gv=gv";
                desc = "Move line down";
              };
              "K" = {
                action = ":m '<-2<CR>gv=gv";
                desc = "Move line up";
              };
            };
          };
        };
      };
    };
  };
}
