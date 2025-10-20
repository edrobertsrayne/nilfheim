{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixvim;
in {
  config = mkIf cfg.enable {
    programs.nixvim.keymaps = let
      # Helper function to create keymaps
      mkKeymap = mode: key: action: desc: {
        inherit mode key action;
        options = {
          inherit desc;
          silent = true;
        };
      };

      # Helper for Lua function keymaps
      mkLuaKeymap = mode: key: luaFn: desc: {
        inherit mode key;
        action.__raw = luaFn;
        options = {
          inherit desc;
          silent = true;
        };
      };
    in [
      # ========================================
      # Core Navigation
      # ========================================

      # Better up/down (respect word wrap)
      {
        mode = "n";
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          silent = true;
        };
      }

      # Tmux navigation is handled by tmux-navigator plugin
      # <C-h>, <C-j>, <C-k>, <C-l> automatically configured

      # Resize window using arrow keys
      (mkKeymap "n" "<C-Up>" "<cmd>resize +2<cr>" "Increase window height")
      (mkKeymap "n" "<C-Down>" "<cmd>resize -2<cr>" "Decrease window height")
      (mkKeymap "n" "<C-Left>" "<cmd>vertical resize -2<cr>" "Decrease window width")
      (mkKeymap "n" "<C-Right>" "<cmd>vertical resize +2<cr>" "Increase window width")

      # ========================================
      # Essential Editor Shortcuts
      # ========================================

      # Clear search with <esc>
      (mkKeymap "n" "<esc>" "<cmd>noh<cr><esc>" "Escape and clear hlsearch")
      (mkKeymap "i" "<esc>" "<cmd>noh<cr><esc>" "Escape and clear hlsearch")

      # Save file
      (mkKeymap "n" "<C-s>" "<cmd>w<cr><esc>" "Save file")
      (mkKeymap "i" "<C-s>" "<cmd>w<cr><esc>" "Save file")
      (mkKeymap "x" "<C-s>" "<cmd>w<cr><esc>" "Save file")
      (mkKeymap "s" "<C-s>" "<cmd>w<cr><esc>" "Save file")

      # Better indenting
      (mkKeymap "v" "<" "<gv" "Indent left")
      (mkKeymap "v" ">" ">gv" "Indent right")

      # Exit insert mode
      (mkKeymap "i" "jk" "<ESC>" "Exit insert mode")

      # Clear search highlights
      (mkKeymap "n" "<leader>nh" ":nohl<CR>" "Clear search highlights")

      # NEW: Redraw / clear hlsearch (LazyVim)
      (mkKeymap "n" "<leader>ur" "<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><cr>" "Redraw / Clear hlsearch")

      # ========================================
      # Window and Buffer Management
      # ========================================

      # Quit
      (mkKeymap "n" "<leader>qq" "<cmd>qa<cr>" "Quit all")

      # Windows
      (mkKeymap "n" "<leader>ww" "<C-W>p" "Other window")
      (mkKeymap "n" "<leader>wd" "<C-W>c" "Delete window")
      (mkKeymap "n" "<leader>w-" "<C-W>s" "Split window below")
      (mkKeymap "n" "<leader>w|" "<C-W>v" "Split window right")

      # NEW: Window splits (LazyVim alternative bindings)
      (mkKeymap "n" "<leader>-" "<C-W>s" "Split window below")
      (mkKeymap "n" "<leader>|" "<C-W>v" "Split window right")

      # Buffer operations
      (mkLuaKeymap "n" "<leader>bd" "function() require('snacks.bufdelete')() end" "Delete Buffer")

      # Buffer navigation (existing)
      (mkKeymap "n" "<S-h>" "<cmd>bprevious<cr>" "Previous buffer")
      (mkKeymap "n" "<S-l>" "<cmd>bnext<cr>" "Next buffer")

      # NEW: Buffer management (LazyVim)
      (mkKeymap "n" "<leader>bb" "<cmd>e #<cr>" "Switch to Other Buffer")
      (mkKeymap "n" "<leader>bo" "<cmd>%bd|e#|bd#<cr>" "Delete Other Buffers")
      (mkLuaKeymap "n" "<leader>bD" "function() require('snacks.bufdelete')() vim.cmd('close') end" "Delete Buffer and Window")
      (mkKeymap "n" "[b" "<cmd>bprevious<cr>" "Prev Buffer")
      (mkKeymap "n" "]b" "<cmd>bnext<cr>" "Next Buffer")

      # NEW: Tab Management (LazyVim)
      (mkKeymap "n" "<leader><tab><tab>" "<cmd>tabnew<cr>" "New Tab")
      (mkKeymap "n" "<leader><tab>d" "<cmd>tabclose<cr>" "Close Tab")
      (mkKeymap "n" "<leader><tab>]" "<cmd>tabnext<cr>" "Next Tab")
      (mkKeymap "n" "<leader><tab>[" "<cmd>tabprevious<cr>" "Previous Tab")
      (mkKeymap "n" "<leader><tab>l" "<cmd>tablast<cr>" "Last Tab")
      (mkKeymap "n" "<leader><tab>o" "<cmd>tabonly<cr>" "Close Other Tabs")

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

      # NEW: LSP Hover and Signature (LazyVim essentials)
      (mkKeymap "n" "K" "<cmd>lua vim.lsp.buf.hover()<cr>" "Hover")
      (mkKeymap "n" "gK" "<cmd>lua vim.lsp.buf.signature_help()<cr>" "Signature Help")
      (mkKeymap "n" "<leader>cl" "<cmd>LspInfo<cr>" "LSP Info")
      (mkKeymap "n" "<leader>ca" "<cmd>lua vim.lsp.buf.code_action()<cr>" "Code Action")
      (mkKeymap "x" "<leader>ca" "<cmd>lua vim.lsp.buf.code_action()<cr>" "Code Action")
      (mkKeymap "n" "<leader>cr" "<cmd>lua vim.lsp.buf.rename()<cr>" "Rename")

      # NEW: Diagnostic Navigation (LazyVim)
      (mkKeymap "n" "<leader>cd" "<cmd>lua vim.diagnostic.open_float()<cr>" "Line Diagnostics")
      (mkKeymap "n" "]d" "<cmd>lua vim.diagnostic.goto_next()<cr>" "Next Diagnostic")
      (mkKeymap "n" "[d" "<cmd>lua vim.diagnostic.goto_prev()<cr>" "Prev Diagnostic")
      (mkKeymap "n" "]e" "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>" "Next Error")
      (mkKeymap "n" "[e" "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>" "Prev Error")
      (mkKeymap "n" "]w" "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN})<cr>" "Next Warning")

      # Trouble keymaps
      (mkKeymap "n" "<leader>xx" "<cmd>Trouble diagnostics toggle<cr>" "Diagnostics (Trouble)")
      (mkKeymap "n" "<leader>xX" "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" "Buffer Diagnostics (Trouble)")
      (mkKeymap "n" "<leader>xL" "<cmd>Trouble loclist toggle<cr>" "Location List (Trouble)")
      (mkKeymap "n" "<leader>xQ" "<cmd>Trouble qflist toggle<cr>" "Quickfix List (Trouble)")

      # Todo comments
      (mkKeymap "n" "<leader>xt" "<cmd>TodoTrouble<cr>" "Todo (Trouble)")
      (mkKeymap "n" "<leader>xq" "<cmd>TodoQuickFix<cr>" "Todo (QuickFix)")

      # NEW: Quickfix Navigation (LazyVim)
      (mkKeymap "n" "[q" "<cmd>cprev<cr>" "Previous Quickfix")
      (mkKeymap "n" "]q" "<cmd>cnext<cr>" "Next Quickfix")

      # ========================================
      # Word Navigation (Snacks Words)
      # ========================================

      (mkLuaKeymap "n" "]]" "function() require('snacks.words').jump(vim.v.count1) end" "Next Reference")
      (mkLuaKeymap "t" "]]" "function() require('snacks.words').jump(vim.v.count1) end" "Next Reference")
      (mkLuaKeymap "n" "[[" "function() require('snacks.words').jump(-vim.v.count1) end" "Prev Reference")
      (mkLuaKeymap "t" "[[" "function() require('snacks.words').jump(-vim.v.count1) end" "Prev Reference")

      # NEW: Better Search Navigation (LazyVim - centered search)
      (mkKeymap "n" "n" "nzzzv" "Next search result")
      (mkKeymap "n" "N" "Nzzzv" "Prev search result")

      # ========================================
      # UI Toggles and Utilities
      # ========================================

      # Existing UI toggles
      (mkLuaKeymap "n" "<leader>z" "function() require('snacks.zen')() end" "Toggle Zen Mode")
      (mkLuaKeymap "n" "<leader>Z" "function() require('snacks.zen').zoom() end" "Toggle Zoom")
      (mkLuaKeymap "n" "<leader>." "function() require('snacks.scratch')() end" "Toggle Scratch Buffer")
      (mkLuaKeymap "n" "<leader>S" "function() require('snacks.scratch').select() end" "Select Scratch Buffer")
      (mkLuaKeymap "n" "<leader>n" "function() require('snacks.notifier').show_history() end" "Notification History")
      (mkLuaKeymap "n" "<leader>un" "function() require('snacks.notifier').hide() end" "Dismiss All Notifications")

      # NEW: UI Toggles (LazyVim)
      (mkKeymap "n" "<leader>ul" "<cmd>set nu!<cr>" "Toggle Line Numbers")
      (mkKeymap "n" "<leader>uL" "<cmd>set rnu!<cr>" "Toggle Relative Line Numbers")
      (mkLuaKeymap "n" "<leader>uc" "function() vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0 end" "Toggle Conceallevel")
      (mkLuaKeymap "n" "<leader>ud" "function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end" "Toggle Diagnostics")
      (mkKeymap "n" "<leader>us" "<cmd>set spell!<cr>" "Toggle Spelling")
      (mkKeymap "n" "<leader>uw" "<cmd>set wrap!<cr>" "Toggle Wrap")
      (mkLuaKeymap "n" "<leader>uf" "function() vim.g.autoformat = not vim.g.autoformat end" "Toggle Auto Format (Global)")
      (mkLuaKeymap "n" "<leader>uF" "function() vim.b.autoformat = not vim.b.autoformat end" "Toggle Auto Format (Buffer)")

      # ========================================
      # File Operations
      # ========================================

      (mkLuaKeymap "n" "<leader>cR" "function() require('snacks.rename').rename_file() end" "Rename File")

      # ========================================
      # Terminal (Snacks)
      # ========================================

      (mkLuaKeymap "n" "<c-/>" "function() require('snacks.terminal')() end" "Toggle Terminal")
      (mkLuaKeymap "n" "<c-_>" "function() require('snacks.terminal')() end" "which_key_ignore")

      # ========================================
      # NEW: Line Movement (LazyVim)
      # ========================================

      # Move lines up/down in normal mode
      (mkKeymap "n" "<A-j>" "<cmd>m .+1<cr>==" "Move line down")
      (mkKeymap "n" "<A-k>" "<cmd>m .-2<cr>==" "Move line up")

      # Move lines up/down in insert mode
      (mkKeymap "i" "<A-j>" "<esc><cmd>m .+1<cr>==gi" "Move line down")
      (mkKeymap "i" "<A-k>" "<esc><cmd>m .-2<cr>==gi" "Move line up")

      # Move lines up/down in visual mode
      (mkKeymap "v" "<A-j>" ":m '>+1<cr>gv=gv" "Move line down")
      (mkKeymap "v" "<A-k>" ":m '<-2<cr>gv=gv" "Move line up")
    ];
  };
}
