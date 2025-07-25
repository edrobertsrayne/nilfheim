{
  programs.nvf.settings.vim.keymaps = let
    # Core navigation keymaps
    coreNavigation = [
      # Better up/down
      {
        key = "j";
        mode = "n";
        action = "v:count == 0 ? 'gj' : 'j'";
        expr = true;
      }
      {
        key = "k";
        mode = "n";
        action = "v:count == 0 ? 'gk' : 'k'";
        expr = true;
      }

      # Move to window using <ctrl> hjkl keys
      {
        key = "<C-h>";
        mode = "n";
        action = "<C-w>h";
        desc = "Go to left window";
      }
      {
        key = "<C-j>";
        mode = "n";
        action = "<C-w>j";
        desc = "Go to lower window";
      }
      {
        key = "<C-k>";
        mode = "n";
        action = "<C-w>k";
        desc = "Go to upper window";
      }
      {
        key = "<C-l>";
        mode = "n";
        action = "<C-w>l";
        desc = "Go to right window";
      }

      # Resize window using <ctrl> arrow keys
      {
        key = "<C-Up>";
        mode = "n";
        action = "<cmd>resize +2<cr>";
        desc = "Increase window height";
      }
      {
        key = "<C-Down>";
        mode = "n";
        action = "<cmd>resize -2<cr>";
        desc = "Decrease window height";
      }
      {
        key = "<C-Left>";
        mode = "n";
        action = "<cmd>vertical resize -2<cr>";
        desc = "Decrease window width";
      }
      {
        key = "<C-Right>";
        mode = "n";
        action = "<cmd>vertical resize +2<cr>";
        desc = "Increase window width";
      }
    ];

    # Essential editor shortcuts
    editorShortcuts = [
      # Clear search with <esc>
      {
        key = "<esc>";
        mode = ["i" "n"];
        action = "<cmd>noh<cr><esc>";
        desc = "Escape and clear hlsearch";
      }

      # Save file
      {
        key = "<C-s>";
        mode = ["i" "x" "n" "s"];
        action = "<cmd>w<cr><esc>";
        desc = "Save file";
      }

      # Better indenting
      {
        key = "<";
        mode = "v";
        action = "<gv";
      }
      {
        key = ">";
        mode = "v";
        action = ">gv";
      }

      # Exit insert mode
      {
        key = "jk";
        mode = ["i"];
        action = "<ESC>";
        desc = "Exit insert mode";
      }

      # Clear search highlights
      {
        key = "<leader>nh";
        mode = ["n"];
        action = ":nohl<CR>";
        desc = "Clear search highlights";
      }
    ];

    # Window and buffer management
    windowManagement = [
      # Quit
      {
        key = "<leader>qq";
        mode = "n";
        action = "<cmd>qa<cr>";
        desc = "Quit all";
      }

      # Windows
      {
        key = "<leader>ww";
        mode = "n";
        action = "<C-W>p";
        desc = "Other window";
      }
      {
        key = "<leader>wd";
        mode = "n";
        action = "<C-W>c";
        desc = "Delete window";
      }
      {
        key = "<leader>w-";
        mode = "n";
        action = "<C-W>s";
        desc = "Split window below";
      }
      {
        key = "<leader>w|";
        mode = "n";
        action = "<C-W>v";
        desc = "Split window right";
      }

      # Buffer operations
      {
        key = "<leader>bd";
        mode = ["n"];
        action = "function() require('snacks.bufdelete')() end";
        lua = true;
        desc = "Delete Buffer";
      }
    ];

    # Git operations
    gitOperations = [
      {
        key = "<leader>gb";
        mode = ["n"];
        action = "function() require('snacks.picker').git_branches() end";
        lua = true;
        desc = "Git Branches";
      }
      {
        key = "<leader>gl";
        mode = ["n"];
        action = "function() require('snacks.picker').git_log() end";
        lua = true;
        desc = "Git Log";
      }
      {
        key = "<leader>gL";
        mode = ["n"];
        action = "function() require('snacks.picker').git_log_line() end";
        lua = true;
        desc = "Git Log Line";
      }
      {
        key = "<leader>gs";
        mode = ["n"];
        action = "function() require('snacks.picker').git_status() end";
        lua = true;
        desc = "Git Status";
      }
      {
        key = "<leader>gS";
        mode = ["n"];
        action = "function() require('snacks.picker').git_stash() end";
        lua = true;
        desc = "Git Stash";
      }
      {
        key = "<leader>gd";
        mode = ["n"];
        action = "function() require('snacks.picker').git_diff() end";
        lua = true;
        desc = "Git Diff (Hunks)";
      }
      {
        key = "<leader>gf";
        mode = ["n"];
        action = "function() require('snacks.picker').git_log_file() end";
        lua = true;
        desc = "Git Log File";
      }
      {
        key = "<leader>gB";
        mode = ["n" "v"];
        action = "function() require('snacks.gitbrowse')() end";
        lua = true;
        desc = "Git Browse";
      }
      {
        key = "<leader>gg";
        mode = ["n"];
        action = "function() require('snacks.lazygit')() end";
        lua = true;
        desc = "lazygit";
      }
    ];

    # File and project navigation
    fileNavigation = [
      # Core Snacks functionality
      {
        key = "<leader><space>";
        mode = ["n"];
        action = "function() require('snacks.picker').smart() end";
        lua = true;
        desc = "Smart Find Files";
      }
      {
        key = "<leader>,";
        mode = ["n"];
        action = "function() require('snacks.picker').buffers() end";
        lua = true;
        desc = "Buffers";
      }
      {
        key = "<leader>/";
        mode = ["n"];
        action = "function() require('snacks.picker').grep() end";
        lua = true;
        desc = "Grep";
      }
      {
        key = "<leader>:";
        mode = ["n"];
        action = "function() require('snacks.picker').command_history() end";
        lua = true;
        desc = "Command History";
      }
      {
        key = "<leader>e";
        mode = ["n"];
        action = "function() require('snacks.explorer')() end";
        lua = true;
        desc = "File Explorer";
      }

      # Find files
      {
        key = "<leader>fb";
        mode = ["n"];
        action = "function() require('snacks.picker').buffers() end";
        lua = true;
        desc = "Buffers";
      }
      {
        key = "<leader>fc";
        mode = ["n"];
        action = "function() require('snacks.picker').files({ cwd = vim.fn.stdpath(\"config\") }) end";
        lua = true;
        desc = "Find Config File";
      }
      {
        key = "<leader>ff";
        mode = ["n"];
        action = "function() require('snacks.picker').files() end";
        lua = true;
        desc = "Find Files";
      }
      {
        key = "<leader>fg";
        mode = ["n"];
        action = "function() require('snacks.picker').git_files() end";
        lua = true;
        desc = "Find Git Files";
      }
      {
        key = "<leader>fp";
        mode = ["n"];
        action = "function() require('snacks.picker').projects() end";
        lua = true;
        desc = "Projects";
      }
      {
        key = "<leader>fr";
        mode = ["n"];
        action = "function() require('snacks.picker').recent() end";
        lua = true;
        desc = "Recent";
      }
    ];

    # Search operations
    searchOperations = [
      {
        key = "<leader>sb";
        mode = ["n"];
        action = "function() require('snacks.picker').lines() end";
        lua = true;
        desc = "Buffer Lines";
      }
      {
        key = "<leader>sB";
        mode = ["n"];
        action = "function() require('snacks.picker').grep_buffers() end";
        lua = true;
        desc = "Grep Open Buffers";
      }
      {
        key = "<leader>sg";
        mode = ["n"];
        action = "function() require('snacks.picker').grep() end";
        lua = true;
        desc = "Grep";
      }
      {
        key = "<leader>sw";
        mode = ["n" "x"];
        action = "function() require('snacks.picker').grep_word() end";
        lua = true;
        desc = "Visual selection or word";
      }
      {
        key = "<leader>s\"";
        mode = ["n"];
        action = "function() require('snacks.picker').registers() end";
        lua = true;
        desc = "Registers";
      }
      {
        key = "<leader>sa";
        mode = ["n"];
        action = "function() require('snacks.picker').autocmds() end";
        lua = true;
        desc = "Autocmds";
      }
      {
        key = "<leader>sc";
        mode = ["n"];
        action = "function() require('snacks.picker').command_history() end";
        lua = true;
        desc = "Command History";
      }
      {
        key = "<leader>sC";
        mode = ["n"];
        action = "function() require('snacks.picker').commands() end";
        lua = true;
        desc = "Commands";
      }
      {
        key = "<leader>sd";
        mode = ["n"];
        action = "function() require('snacks.picker').diagnostics() end";
        lua = true;
        desc = "Diagnostics";
      }
      {
        key = "<leader>sD";
        mode = ["n"];
        action = "function() require('snacks.picker').diagnostics_buffer() end";
        lua = true;
        desc = "Buffer Diagnostics";
      }
      {
        key = "<leader>sh";
        mode = ["n"];
        action = "function() require('snacks.picker').help() end";
        lua = true;
        desc = "Help Pages";
      }
      {
        key = "<leader>sH";
        mode = ["n"];
        action = "function() require('snacks.picker').highlights() end";
        lua = true;
        desc = "Highlights";
      }
      {
        key = "<leader>si";
        mode = ["n"];
        action = "function() require('snacks.picker').icons() end";
        lua = true;
        desc = "Icons";
      }
      {
        key = "<leader>sj";
        mode = ["n"];
        action = "function() require('snacks.picker').jumps() end";
        lua = true;
        desc = "Jumps";
      }
      {
        key = "<leader>sk";
        mode = ["n"];
        action = "function() require('snacks.picker').keymaps() end";
        lua = true;
        desc = "Keymaps";
      }
      {
        key = "<leader>sl";
        mode = ["n"];
        action = "function() require('snacks.picker').loclist() end";
        lua = true;
        desc = "Location List";
      }
      {
        key = "<leader>sm";
        mode = ["n"];
        action = "function() require('snacks.picker').marks() end";
        lua = true;
        desc = "Marks";
      }
      {
        key = "<leader>sM";
        mode = ["n"];
        action = "function() require('snacks.picker').man() end";
        lua = true;
        desc = "Man Pages";
      }
      {
        key = "<leader>sq";
        mode = ["n"];
        action = "function() require('snacks.picker').qflist() end";
        lua = true;
        desc = "Quickfix List";
      }
      {
        key = "<leader>sR";
        mode = ["n"];
        action = "function() require('snacks.picker').resume() end";
        lua = true;
        desc = "Resume";
      }
      {
        key = "<leader>su";
        mode = ["n"];
        action = "function() require('snacks.picker').undo() end";
        lua = true;
        desc = "Undo History";
      }
      {
        key = "<leader>uC";
        mode = ["n"];
        action = "function() require('snacks.picker').colorschemes() end";
        lua = true;
        desc = "Colorschemes";
      }
    ];

    # LSP navigation and operations
    lspOperations = [
      {
        key = "gd";
        mode = ["n"];
        action = "function() require('snacks.picker').lsp_definitions() end";
        lua = true;
        desc = "Goto Definition";
      }
      {
        key = "gD";
        mode = ["n"];
        action = "function() require('snacks.picker').lsp_declarations() end";
        lua = true;
        desc = "Goto Declaration";
      }
      {
        key = "gr";
        mode = ["n"];
        action = "function() require('snacks.picker').lsp_references() end";
        lua = true;
        desc = "References";
        nowait = true;
      }
      {
        key = "gI";
        mode = ["n"];
        action = "function() require('snacks.picker').lsp_implementations() end";
        lua = true;
        desc = "Goto Implementation";
      }
      {
        key = "gy";
        mode = ["n"];
        action = "function() require('snacks.picker').lsp_type_definitions() end";
        lua = true;
        desc = "Goto T[y]pe Definition";
      }
      {
        key = "<leader>ss";
        mode = ["n"];
        action = "function() require('snacks.picker').lsp_symbols() end";
        lua = true;
        desc = "LSP Symbols";
      }
      {
        key = "<leader>sS";
        mode = ["n"];
        action = "function() require('snacks.picker').lsp_workspace_symbols() end";
        lua = true;
        desc = "LSP Workspace Symbols";
      }
    ];

    # Word navigation and text objects
    wordNavigation = [
      {
        key = "]]";
        mode = ["n" "t"];
        action = "function() require('snacks.words').jump(vim.v.count1) end";
        lua = true;
        desc = "Next Reference";
      }
      {
        key = "[[";
        mode = ["n" "t"];
        action = "function() require('snacks.words').jump(-vim.v.count1) end";
        lua = true;
        desc = "Prev Reference";
      }
    ];

    # UI toggles and utilities
    uiToggles = [
      {
        key = "<leader>z";
        mode = ["n"];
        action = "function() require('snacks.zen')() end";
        lua = true;
        desc = "Toggle Zen Mode";
      }
      {
        key = "<leader>Z";
        mode = ["n"];
        action = "function() require('snacks.zen').zoom() end";
        lua = true;
        desc = "Toggle Zoom";
      }
      {
        key = "<leader>.";
        mode = ["n"];
        action = "function() require('snacks.scratch')() end";
        lua = true;
        desc = "Toggle Scratch Buffer";
      }
      {
        key = "<leader>S";
        mode = ["n"];
        action = "function() require('snacks.scratch').select() end";
        lua = true;
        desc = "Select Scratch Buffer";
      }
      {
        key = "<leader>n";
        mode = ["n"];
        action = "function() require('snacks.notifier').show_history() end";
        lua = true;
        desc = "Notification History";
      }
      {
        key = "<leader>un";
        mode = ["n"];
        action = "function() require('snacks.notifier').hide() end";
        lua = true;
        desc = "Dismiss All Notifications";
      }
    ];

    # File operations
    fileOperations = [
      {
        key = "<leader>cR";
        mode = ["n"];
        action = "function() require('snacks.rename').rename_file() end";
        lua = true;
        desc = "Rename File";
      }
    ];

    # Terminal
    terminal = [
      {
        key = "<c-/>";
        mode = ["n"];
        action = "function() require('snacks.terminal')() end";
        lua = true;
        desc = "Toggle Terminal";
      }
      {
        key = "<c-_>";
        mode = ["n"];
        action = "function() require('snacks.terminal')() end";
        lua = true;
        desc = "which_key_ignore";
      }
    ];
  in
    # Combine all keymap categories
    coreNavigation
    ++ editorShortcuts
    ++ windowManagement
    ++ gitOperations
    ++ fileNavigation
    ++ searchOperations
    ++ lspOperations
    ++ wordNavigation
    ++ uiToggles
    ++ fileOperations
    ++ terminal;
}
