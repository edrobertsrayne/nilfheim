{
  programs.nvf.settings.vim.keymaps = [
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
