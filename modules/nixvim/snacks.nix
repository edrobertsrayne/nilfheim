{inputs, ...}: let
  inherit (inputs.self.lib.nixvim) mkKeymap mkLuaKeymap;
in {
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      plugins.snacks = {
        enable = true;
        settings = {
          lazygit.enabled = true;
          words.enabled = true;
          scroll = {
            enabled = true;
            animate = {
              duration = {
                step = 15;
                total = 250;
              };
              easing = "linear";
            };
            gitbrowser.enabled = true;
            picker.enabled = true;
            explorer.enabled = true;
            bufdelete.enabled = true;
            rename.enabled = true;
            scratch.enabled = true;
            terminal.enabled = true;
            zen.enabled = true;
            statuscolumn.enabled = true;
            input.enabled = true;
            scope.enabled = true;
            dim.enabled = true;
            bigfile = {
              enabled = true;
              size = 1572864; # 1.5MB
            };
            quickfile.enabled = true;
            indent = {
              enabled = true;
              animate.enabled = true;
            };
            win.enabled = true;
            toggle.enabled = true;
          };
        };
      };

      keymaps = [
        # ========================================
        # Git Operations (Snacks Picker)
        # ========================================

        (mkLuaKeymap "n" "<leader>gb" "function() require('snacks.picker').git_branches() end" "Git Branches")
        (mkLuaKeymap "n" "<leader>gl" "function() require('snacks.picker').git_log() end" "Git Log")
        (mkLuaKeymap "n" "<leader>gL" "function() require('snacks.picker').git_log_line() end" "Git Log Line")
        (mkLuaKeymap "n" "<leader>gs" "function() require('snacks.picker').git_status() end" "Git Status")
        (mkLuaKeymap "n" "<leader>gS" "function() require('snacks.picker').git_stash() end" "Git Stash")
        (mkLuaKeymap "n" "<leader>gd" "function() require('snacks.picker').git_diff() end" "Git Diff (Hunks)")
        (mkLuaKeymap "n" "<leader>gf" "function() require('snacks.picker').git_log_file() end" "Git Log File")
        (mkLuaKeymap "n" "<leader>gB" "function() require('snacks.gitbrowse')() end" "Git Browse")
        (mkLuaKeymap "v" "<leader>gB" "function() require('snacks.gitbrowse')() end" "Git Browse")
        (mkLuaKeymap "n" "<leader>gg" "function() require('snacks.lazygit')() end" "Lazygit")

        # Gitsigns keymaps
        (mkKeymap "n" "<leader>hs" "<cmd>Gitsigns stage_hunk<cr>" "Stage Hunk")
        (mkKeymap "n" "<leader>hr" "<cmd>Gitsigns reset_hunk<cr>" "Reset Hunk")
        (mkKeymap "n" "<leader>hp" "<cmd>Gitsigns preview_hunk<cr>" "Preview Hunk")
        (mkKeymap "n" "<leader>hb" "<cmd>Gitsigns blame_line<cr>" "Blame Line")
        (mkKeymap "n" "]h" "<cmd>Gitsigns next_hunk<cr>" "Next Hunk")
        (mkKeymap "n" "[h" "<cmd>Gitsigns prev_hunk<cr>" "Prev Hunk")

        # ========================================
        # File and Project Navigation (Snacks)
        # ========================================

        # Core Snacks functionality
        (mkLuaKeymap "n" "<leader><space>" "function() require('snacks.picker').smart() end" "Smart Find Files")
        (mkLuaKeymap "n" "<leader>," "function() require('snacks.picker').buffers() end" "Buffers")
        (mkLuaKeymap "n" "<leader>/" "function() require('snacks.picker').grep() end" "Grep")
        (mkLuaKeymap "n" "<leader>:" "function() require('snacks.picker').command_history() end" "Command History")
        (mkLuaKeymap "n" "<leader>e" "function() require('snacks.explorer')() end" "File Explorer")

        # Find files
        (mkLuaKeymap "n" "<leader>fb" "function() require('snacks.picker').buffers() end" "Buffers")
        (mkLuaKeymap "n" "<leader>fc" "function() require('snacks.picker').files({ cwd = vim.fn.stdpath('config') }) end" "Find Config File")
        (mkLuaKeymap "n" "<leader>ff" "function() require('snacks.picker').files() end" "Find Files")
        (mkLuaKeymap "n" "<leader>fg" "function() require('snacks.picker').git_files() end" "Find Git Files")
        (mkLuaKeymap "n" "<leader>fp" "function() require('snacks.picker').projects() end" "Projects")
        (mkLuaKeymap "n" "<leader>fr" "function() require('snacks.picker').recent() end" "Recent")

        # ========================================
        # Search Operations (Snacks)
        # ========================================

        (mkLuaKeymap "n" "<leader>sb" "function() require('snacks.picker').lines() end" "Buffer Lines")
        (mkLuaKeymap "n" "<leader>sB" "function() require('snacks.picker').grep_buffers() end" "Grep Open Buffers")
        (mkLuaKeymap "n" "<leader>sg" "function() require('snacks.picker').grep() end" "Grep")
        (mkLuaKeymap "n" "<leader>sw" "function() require('snacks.picker').grep_word() end" "Visual selection or word")
        (mkLuaKeymap "x" "<leader>sw" "function() require('snacks.picker').grep_word() end" "Visual selection or word")
        (mkLuaKeymap "n" "<leader>s\"" "function() require('snacks.picker').registers() end" "Registers")
        (mkLuaKeymap "n" "<leader>sa" "function() require('snacks.picker').autocmds() end" "Autocmds")
        (mkLuaKeymap "n" "<leader>sc" "function() require('snacks.picker').command_history() end" "Command History")
        (mkLuaKeymap "n" "<leader>sC" "function() require('snacks.picker').commands() end" "Commands")
        (mkLuaKeymap "n" "<leader>sd" "function() require('snacks.picker').diagnostics() end" "Diagnostics")
        (mkLuaKeymap "n" "<leader>sD" "function() require('snacks.picker').diagnostics_buffer() end" "Buffer Diagnostics")
        (mkLuaKeymap "n" "<leader>sh" "function() require('snacks.picker').help() end" "Help Pages")
        (mkLuaKeymap "n" "<leader>sH" "function() require('snacks.picker').highlights() end" "Highlights")
        (mkLuaKeymap "n" "<leader>si" "function() require('snacks.picker').icons() end" "Icons")
        (mkLuaKeymap "n" "<leader>sj" "function() require('snacks.picker').jumps() end" "Jumps")
        (mkLuaKeymap "n" "<leader>sk" "function() require('snacks.picker').keymaps() end" "Keymaps")
        (mkLuaKeymap "n" "<leader>sl" "function() require('snacks.picker').loclist() end" "Location List")
        (mkLuaKeymap "n" "<leader>sm" "function() require('snacks.picker').marks() end" "Marks")
        (mkLuaKeymap "n" "<leader>sM" "function() require('snacks.picker').man() end" "Man Pages")
        (mkLuaKeymap "n" "<leader>sq" "function() require('snacks.picker').qflist() end" "Quickfix List")
        (mkLuaKeymap "n" "<leader>sR" "function() require('snacks.picker').resume() end" "Resume")
        (mkLuaKeymap "n" "<leader>su" "function() require('snacks.picker').undo() end" "Undo History")
        (mkLuaKeymap "n" "<leader>uC" "function() require('snacks.picker').colorschemes() end" "Colorschemes")

        # ========================================
        # LSP Navigation and Operations
        # ========================================

        # Existing LSP keymaps
        (mkLuaKeymap "n" "gd" "function() require('snacks.picker').lsp_definitions() end" "Goto Definition")
        (mkLuaKeymap "n" "gD" "function() require('snacks.picker').lsp_declarations() end" "Goto Declaration")
        (mkLuaKeymap "n" "gr" "function() require('snacks.picker').lsp_references() end" "References")
        (mkLuaKeymap "n" "gI" "function() require('snacks.picker').lsp_implementations() end" "Goto Implementation")
        (mkLuaKeymap "n" "gy" "function() require('snacks.picker').lsp_type_definitions() end" "Goto T[y]pe Definition")
        (mkLuaKeymap "n" "<leader>ss" "function() require('snacks.picker').lsp_symbols() end" "LSP Symbols")
        (mkLuaKeymap "n" "<leader>sS" "function() require('snacks.picker').lsp_workspace_symbols() end" "LSP Workspace Symbols")
      ];
    };
  };
}
