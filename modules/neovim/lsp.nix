_: {
  flake.modules.homeManager.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = true;
            lspkind.enable = true;
          };

          maps = {
            normal = {
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
            };

            insert = {
              # === LSP in insert mode ===
              "<C-k>" = {
                action = "vim.lsp.buf.signature_help";
                lua = true;
                desc = "Signature help";
              };
            };

            visual = {
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
          };
        };
      };
    };
  };
}
