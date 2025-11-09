_: {
  flake.modules.homeManager.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          utility = {
            snacks-nvim = {
              enable = true;
              setupOpts = {
                bigfile.enabled = true;
                quickfile.enabled = true;
                notifier.enabled = true;
                picker.enabled = true;
                terminal.enabled = true;
                indent.enabled = true;
                scroll.enabled = true;
                explorer.enabled = true;
                zen.enabled = true;
                scratch.enabled = true;
                lazygit.enabled = true;
                gitbrowse.enabled = true;
                bufdelete.enabled = true;
                rename.enabled = true;
                words.enabled = true;
                statuscolumn.enabled = true;
                dim.enabled = true;
                input.enabled = true;
                toggle.enabled = true;
                scope.enabled = true;
                win.enabled = true;
              };
            };
          };
          maps = {
            normal = {
              # GitHub pickers
              "<leader>gi" = {
                action = "function() Snacks.picker.gh_issue() end";
                lua = true;
                desc = "GitHub Issues (open)";
              };
              "<leader>gI" = {
                action = "function() Snacks.picker.gh_issue({ state = \"all\" }) end";
                lua = true;
                desc = "GitHub Issues (all)";
              };
              "<leader>gp" = {
                action = "function() Snacks.picker.gh_pr() end";
                lua = true;
                desc = "GitHub Pull Requests (open)";
              };
              "<leader>gP" = {
                action = "function() Snacks.picker.gh_pr({ state = \"all\" }) end";
                lua = true;
                desc = "GitHub Pull Requests (all)";
              };

              # File pickers
              "<leader><space>" = {
                action = "function() Snacks.picker.files() end";
                lua = true;
                desc = "Find Files (root)";
              };
              "<leader>ff" = {
                action = "function() Snacks.picker.files() end";
                lua = true;
                desc = "Find Files (root)";
              };
              "<leader>fF" = {
                action = "function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end";
                lua = true;
                desc = "Find Files (cwd)";
              };
              "<leader>fg" = {
                action = "function() Snacks.picker.git_files() end";
                lua = true;
                desc = "Git Files";
              };
              "<leader>fb" = {
                action = "function() Snacks.picker.buffers() end";
                lua = true;
                desc = "Buffers";
              };
              "<leader>," = {
                action = "function() Snacks.picker.buffers() end";
                lua = true;
                desc = "Buffers";
              };
              "<leader>fr" = {
                action = "function() Snacks.picker.recent() end";
                lua = true;
                desc = "Recent Files";
              };
              "<leader>fR" = {
                action = "function() Snacks.picker.recent({ cwd = vim.fn.getcwd() }) end";
                lua = true;
                desc = "Recent Files (cwd)";
              };

              # Grep/search
              "<leader>/" = {
                action = "function() Snacks.picker.grep() end";
                lua = true;
                desc = "Grep (root)";
              };
              "<leader>sg" = {
                action = "function() Snacks.picker.grep() end";
                lua = true;
                desc = "Grep (root)";
              };
              "<leader>sG" = {
                action = "function() Snacks.picker.grep({ cwd = vim.fn.getcwd() }) end";
                lua = true;
                desc = "Grep (cwd)";
              };

              # History
              "<leader>:" = {
                action = "function() Snacks.picker.command_history() end";
                lua = true;
                desc = "Command History";
              };
              "<leader>s/" = {
                action = "function() Snacks.picker.search_history() end";
                lua = true;
                desc = "Search History";
              };

              # Explorer
              "<leader>e" = {
                action = "function() Snacks.explorer() end";
                lua = true;
                desc = "Explorer (root)";
              };
              "<leader>E" = {
                action = "function() Snacks.explorer({ cwd = vim.fn.getcwd() }) end";
                lua = true;
                desc = "Explorer (cwd)";
              };

              # Notifications & scratch
              "<leader>n" = {
                action = "function() Snacks.notifier.show_history() end";
                lua = true;
                desc = "Notification History";
              };
              "<leader>un" = {
                action = "function() Snacks.notifier.hide() end";
                lua = true;
                desc = "Dismiss Notifications";
              };
              "<leader>." = {
                action = "function() Snacks.scratch() end";
                lua = true;
                desc = "Toggle Scratch Buffer";
              };
              "<leader>S" = {
                action = "function() Snacks.scratch.select() end";
                lua = true;
                desc = "Select Scratch Buffer";
              };

              # Zen mode
              "<leader>uz" = {
                action = "function() Snacks.zen() end";
                lua = true;
                desc = "Toggle Zen Mode";
              };
            };
            terminal = {
              # Terminal
              "<C-/>" = {
                action = "function() Snacks.terminal() end";
                lua = true;
                desc = "Toggle Terminal";
              };
            };
          };
        };
      };
    };
  };
}
