{
  programs.nvf.settings.vim.keymaps = [
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

    # Move to window using the <ctrl> hjkl keys
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

    # Word navigation (using snacks.words)
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

    {
      key = "<leader>gg";
      mode = ["n"];
      action = "<cmd>lua require('snacks.lazygit')()<CR>";
      desc = "Open lazygit";
    }
    {
      key = "<leader>e";
      mode = ["n"];
      action = "<cmd>Neotree toggle<CR>";
      desc = "Toggle file explorer [Neotree]";
    }
    {
      key = "jk";
      mode = ["i"];
      action = "<ESC>";
      desc = "Exit insert mode";
    }
    {
      key = "<leader>nh";
      mode = ["n"];
      action = ":nohl<CR>";
      desc = "Clear search highlights";
    }
    {
      key = "<leader>be";
      action = ":Neotree float buffers<CR>";
      mode = ["n"];
      desc = "Buffer list";
    }
    {
      key = "<leader>ge";
      action = ":Neotree float git_status<CR>";
      mode = ["n"];
      desc = "List git status [NeoTree]";
    }
    {
      key = "<leader><space>";
      mode = ["n"];
      action = "<cmd>Telescope find_files<CR>";
      desc = "Find Files [Telescope]";
    }
    {
      key = "<leader>/";
      mode = ["n"];
      action = "<cmd>Telescope live_grep<CR>";
      desc = "Live Grep [Telescope]";
    }
    {
      key = "<leader>,";
      mode = ["n"];
      action = "<cmd>Telescope buffers<CR>";
      desc = "Buffers [Telescope]";
    }
    {
      key = "<leader>fC";
      mode = ["n"];
      action = "<cmd>Telescope commands<CR>";
      desc = "Commands";
    }
    {
      key = "<leader>fd";
      mode = ["n"];
      action = "<cmd>Telescope diagnostics<CR>";
      desc = "Diagnostics";
    }
    {
      key = "<leader>fc";
      mode = ["n"];
      action = "<cmd>Telescope commands_history<CR>";
      desc = "Command history";
    }
    {
      key = "<leader>fh";
      mode = ["n"];
      action = "<cmd>Telescope help_tags";
      desc = "Help";
    }
    {
      key = "<leader>fq";
      mode = ["n"];
      action = "<cmd>Telescope quickfix<CR>";
      desc = "Quickfix list";
    }
    {
      key = "<leader>f/";
      mode = ["n"];
      action = "<cmd>Telescope search_history<CR>";
      desc = "Search history";
    }
  ];
}
