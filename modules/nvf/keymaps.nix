_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          # ===== KEYMAPS =====
          # Custom key bindings (LazyVim-inspired)
          # Leader key is <Space> by default in nvf
          maps = {
            normal = {
              # === General ===
              # Quick save
              "<leader>w" = {
                action = ":w<CR>";
                desc = "Save file";
              };

              # === LSP ===
              # Hover documentation
              "K" = {
                action = "vim.lsp.buf.hover";
                lua = true;
                desc = "Hover documentation";
              };
              # Go to definition
              "gd" = {
                action = "vim.lsp.buf.definition";
                lua = true;
                desc = "Go to definition";
              };
              # Go to references
              "gr" = {
                action = "vim.lsp.buf.references";
                lua = true;
                desc = "Go to references";
              };
              # Code actions
              "<leader>ca" = {
                action = "vim.lsp.buf.code_action";
                lua = true;
                desc = "Code actions";
              };
              # Rename symbol
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

            # Insert mode mappings
            insert = {
              # Quick escape
              "jk" = {
                action = "<Esc>";
                desc = "Exit insert mode";
              };
            };

            # Visual mode mappings
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

              # Move lines up/down
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
