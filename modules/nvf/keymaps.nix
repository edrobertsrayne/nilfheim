_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          maps = {
            normal = {
              # === Save ===
              "<leader>w" = {
                action = ":w<CR>";
                desc = "Save file";
              };
              "<C-s>" = {
                action = ":w<CR>";
                desc = "Save file";
              };

              # === LSP (quick access) ===
              "K" = {
                action = "vim.lsp.buf.hover";
                lua = true;
                desc = "Hover documentation";
              };
              "gK" = {
                action = "vim.lsp.buf.signature_help";
                lua = true;
                desc = "Signature help";
              };
              "gd" = {
                action = "vim.lsp.buf.definition";
                lua = true;
                desc = "Go to definition";
              };
              "gD" = {
                action = "vim.lsp.buf.declaration";
                lua = true;
                desc = "Go to declaration";
              };
              "gr" = {
                action = "vim.lsp.buf.references";
                lua = true;
                desc = "Go to references";
              };
              "gI" = {
                action = "vim.lsp.buf.implementation";
                lua = true;
                desc = "Go to implementation";
              };
              "gy" = {
                action = "vim.lsp.buf.type_definition";
                lua = true;
                desc = "Go to type definition";
              };

              # === Code/LSP ===
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
              "<leader>cf" = {
                action = "vim.lsp.buf.format";
                lua = true;
                desc = "Format code/buffer";
              };
              "<leader>cD" = {
                action = "vim.lsp.buf.declaration";
                lua = true;
                desc = "Go to declaration";
              };
              "<leader>ci" = {
                action = "vim.lsp.buf.implementation";
                lua = true;
                desc = "Go to implementation";
              };
              "<leader>cy" = {
                action = "vim.lsp.buf.type_definition";
                lua = true;
                desc = "Go to type definition";
              };
              "<leader>ch" = {
                action = "vim.lsp.buf.hover";
                lua = true;
                desc = "Hover documentation";
              };
              "<leader>cd" = {
                action = "vim.diagnostic.open_float";
                lua = true;
                desc = "Line diagnostics";
              };

              # === Telescope (Find) ===
              "<leader>e" = {
                action = "<cmd>Neotree toggle<CR>";
                desc = "Toggle NeoTree";
              };

              # === Telescope (Find) ===
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

              # === Buffer management ===
              "<leader>bd" = {
                action = ":bdelete<CR>";
                desc = "Delete buffer";
              };
              "<leader>bb" = {
                action = "<cmd>e #<CR>";
                desc = "Switch to alternate buffer";
              };
              "<leader>bo" = {
                action = "<cmd>%bd|e#|bd#<CR>";
                desc = "Delete other buffers";
              };
              "<leader>bD" = {
                action = "<cmd>bd<CR><cmd>close<CR>";
                desc = "Delete buffer and window";
              };
              "<S-h>" = {
                action = ":bprevious<CR>";
                desc = "Previous buffer";
              };
              "<S-l>" = {
                action = ":bnext<CR>";
                desc = "Next buffer";
              };
              "[b" = {
                action = ":bprevious<CR>";
                desc = "Previous buffer";
              };
              "]b" = {
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

              # === Window management ===
              "<leader>wd" = {
                action = "<C-w>c";
                desc = "Delete/close window";
              };
              "<leader>-" = {
                action = "<C-w>s";
                desc = "Split window horizontally";
              };
              "<leader>|" = {
                action = "<C-w>v";
                desc = "Split window vertically";
              };

              # === Window resize ===
              "<C-Up>" = {
                action = ":resize +2<CR>";
                desc = "Increase window height";
              };
              "<C-Down>" = {
                action = ":resize -2<CR>";
                desc = "Decrease window height";
              };
              "<C-Left>" = {
                action = ":vertical resize -2<CR>";
                desc = "Decrease window width";
              };
              "<C-Right>" = {
                action = ":vertical resize +2<CR>";
                desc = "Increase window width";
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

              # === Clear search highlights ===
              "<Esc>" = {
                action = ":noh<CR><Esc>";
                desc = "Clear search highlights";
              };

              # === Diagnostics ===
              "]d" = {
                action = "function() vim.diagnostic.goto_next() end";
                lua = true;
                desc = "Next diagnostic";
              };
              "[d" = {
                action = "function() vim.diagnostic.goto_prev() end";
                lua = true;
                desc = "Previous diagnostic";
              };
              "]e" = {
                action = "function() vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR}) end";
                lua = true;
                desc = "Next error";
              };
              "[e" = {
                action = "function() vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR}) end";
                lua = true;
                desc = "Previous error";
              };
              "]w" = {
                action = "function() vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN}) end";
                lua = true;
                desc = "Next warning";
              };
              "[w" = {
                action = "function() vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARN}) end";
                lua = true;
                desc = "Previous warning";
              };

              # === Git hunks ===
              "]h" = {
                action = "<cmd>Gitsigns next_hunk<CR>";
                desc = "Next git hunk";
              };
              "[h" = {
                action = "<cmd>Gitsigns prev_hunk<CR>";
                desc = "Previous git hunk";
              };
              "<leader>gb" = {
                action = "<cmd>Gitsigns blame_line<CR>";
                desc = "Git blame line";
              };
              "<leader>gd" = {
                action = "<cmd>Gitsigns diffthis<CR>";
                desc = "Git diff";
              };
              "<leader>gp" = {
                action = "<cmd>Gitsigns preview_hunk<CR>";
                desc = "Preview git hunk";
              };
              "<leader>gr" = {
                action = "<cmd>Gitsigns reset_hunk<CR>";
                desc = "Reset hunk";
              };
              "<leader>gS" = {
                action = "<cmd>Gitsigns stage_buffer<CR>";
                desc = "Stage buffer";
              };
              "<leader>gu" = {
                action = "<cmd>Gitsigns undo_stage_hunk<CR>";
                desc = "Undo stage hunk";
              };

              # === Terminal ===
              "<C-_>" = {
                action = "<cmd>ToggleTerm<CR>";
                desc = "Toggle terminal";
              };
            };

            insert = {
              "jk" = {
                action = "<Esc>";
                desc = "Exit insert mode";
              };

              # === Save in insert mode ===
              "<C-s>" = {
                action = "<Esc>:w<CR>a";
                desc = "Save file";
              };

              # === LSP in insert mode ===
              "<C-k>" = {
                action = "vim.lsp.buf.signature_help";
                lua = true;
                desc = "Signature help";
              };

              # === Move lines in insert mode ===
              "<A-j>" = {
                action = "<Esc>:m .+1<CR>==gi";
                desc = "Move line down";
              };
              "<A-k>" = {
                action = "<Esc>:m .-2<CR>==gi";
                desc = "Move line up";
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

              # === Move lines in visual mode ===
              "J" = {
                action = ":m '>+1<CR>gv=gv";
                desc = "Move line down";
              };
              "K" = {
                action = ":m '<-2<CR>gv=gv";
                desc = "Move line up";
              };
              "<A-j>" = {
                action = ":m '>+1<CR>gv=gv";
                desc = "Move line down";
              };
              "<A-k>" = {
                action = ":m '<-2<CR>gv=gv";
                desc = "Move line up";
              };

              # === Code/LSP in visual mode ===
              "<leader>ca" = {
                action = "vim.lsp.buf.code_action";
                lua = true;
                desc = "Code actions";
              };
              "<leader>cf" = {
                action = "vim.lsp.buf.format";
                lua = true;
                desc = "Format selection";
              };
            };

            # === Terminal mode ===
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
