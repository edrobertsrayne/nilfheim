_: {
  flake.modules.homeManager.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          git = {
            enable = true;
            gitsigns = {
              enable = true;
            };
          };

          maps = {
            normal = {
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
              "<leader>gh" = {
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

              # === LazyGit ===
              "<leader>gg" = {
                action = "function() Snacks.lazygit() end";
                lua = true;
                desc = "LazyGit (root)";
              };
              "<leader>gG" = {
                action = "function() Snacks.lazygit({ cwd = vim.fn.getcwd() }) end";
                lua = true;
                desc = "LazyGit (cwd)";
              };

              # === Git Browse ===
              "<leader>gB" = {
                action = "function() Snacks.gitbrowse() end";
                lua = true;
                desc = "Git Browse (open)";
              };
              "<leader>gY" = {
                action = "function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg('+', url) end }) end";
                lua = true;
                desc = "Git Browse (copy)";
              };
            };
          };
        };
      };
    };
  };
}
