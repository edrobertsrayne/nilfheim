{
  programs.nvf.settings.vim = {
    autocomplete.nvim-cmp.enable = true;

    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        lazygit = {enable = true;};
        indent = {enable = true;};
        scroll = {enable = true;};
        words = {enable = true;};
      };
    };

    autopairs.nvim-autopairs.enable = true;

    binds = {
      whichKey = {
        enable = true;
        setupOpts = {
          preset = "helix";
        };
        register = {
          "<leader>f" = "Find";
          "<leader>g" = "Git";
          "<leader>s" = "Search";
          "<leader>u" = "UI";
          "<leader>w" = "Windows";
          "<leader>x" = "Diagnostics/Quickfix";
          "<leader>q" = "Quit/Session";
          "<leader>c" = "Code";
          "<leader>b" = "Buffers";
          "<leader>t" = "Terminal";
          "<leader>n" = "Notifications";
        };
      };
    };

    comments.comment-nvim.enable = true;

    dashboard.alpha.enable = true;

    filetree.neo-tree.enable = true;

    git = {
      enable = true;
      gitsigns.enable = true;
    };

    notes.todo-comments.enable = true;

    notify.nvim-notify.enable = true;

    mini = {
      basics.enable = true;
      surround.enable = true;
    };

    snippets.luasnip.enable = true;

    spellcheck.enable = true;

    statusline.lualine.enable = true;

    tabline.nvimBufferline = {
      enable = true;
      mappings = {
        closeCurrent = "<leader>bd";
      };
    };

    telescope = {
      enable = true;
    };

    terminal.toggleterm = {
      enable = true;
    };

    treesitter.context.enable = true;

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;
      modes-nvim.enable = false; # the theme looks terrible with catppuccin
      illuminate.enable = true;
      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          nix = "110";
          ruby = "120";
          java = "130";
          go = ["90" "130"];
        };
      };
      fastaction.enable = true;
    };

    utility = {
      diffview-nvim.enable = true;
      motion = {
        hop.enable = true;
        leap.enable = true;
      };
    };

    visuals = {
      nvim-web-devicons.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;
      highlight-undo.enable = true;
    };
  };
}
