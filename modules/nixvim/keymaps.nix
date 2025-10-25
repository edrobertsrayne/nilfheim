{inputs, ...}: let
  inherit (inputs.self.lib.nixvim) mkKeymap mkLuaKeymap;
in {
  flake.modules.homeManager.nixvim = {
    programs.nixvim.keymaps = [
      # NEW: Quickfix Navigation (LazyVim)
      (mkKeymap "n" "[q" "<cmd>cprev<cr>" "Previous Quickfix")
      (mkKeymap "n" "]q" "<cmd>cnext<cr>" "Next Quickfix")

      # NEW: Better Search Navigation (LazyVim - centered search)
      (mkKeymap "n" "n" "nzzzv" "Next search result")
      (mkKeymap "n" "N" "Nzzzv" "Prev search result")

      # NEW: UI Toggles (LazyVim)
      (mkKeymap "n" "<leader>ul" "<cmd>set nu!<cr>" "Toggle Line Numbers")
      (mkKeymap "n" "<leader>uL" "<cmd>set rnu!<cr>" "Toggle Relative Line Numbers")
      (mkLuaKeymap "n" "<leader>uc" "function() vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0 end" "Toggle Conceallevel")
      (mkLuaKeymap "n" "<leader>ud" "function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end" "Toggle Diagnostics")
      (mkKeymap "n" "<leader>us" "<cmd>set spell!<cr>" "Toggle Spelling")
      (mkKeymap "n" "<leader>uw" "<cmd>set wrap!<cr>" "Toggle Wrap")
      (mkLuaKeymap "n" "<leader>uf" "function() vim.g.autoformat = not vim.g.autoformat end" "Toggle Auto Format (Global)")
      (mkLuaKeymap "n" "<leader>uF" "function() vim.b.autoformat = not vim.b.autoformat end" "Toggle Auto Format (Buffer)")

      # Move lines up/down in normal mode
      (mkKeymap "n" "<A-j>" "<cmd>m .+1<cr>==" "Move line down")
      (mkKeymap "n" "<A-k>" "<cmd>m .-2<cr>==" "Move line up")

      # Move lines up/down in insert mode
      (mkKeymap "i" "<A-j>" "<esc><cmd>m .+1<cr>==gi" "Move line down")
      (mkKeymap "i" "<A-k>" "<esc><cmd>m .-2<cr>==gi" "Move line up")

      # Move lines up/down in visual mode
      (mkKeymap "v" "<A-j>" ":m '>+1<cr>gv=gv" "Move line down")
      (mkKeymap "v" "<A-k>" ":m '<-2<cr>gv=gv" "Move line up")

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

      # Resize window using arrow keys
      (mkKeymap "n" "<C-Up>" "<cmd>resize +2<cr>" "Increase window height")
      (mkKeymap "n" "<C-Down>" "<cmd>resize -2<cr>" "Decrease window height")
      (mkKeymap "n" "<C-Left>" "<cmd>vertical resize -2<cr>" "Decrease window width")
      (mkKeymap "n" "<C-Right>" "<cmd>vertical resize +2<cr>" "Increase window width")

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
    ];
  };
}
