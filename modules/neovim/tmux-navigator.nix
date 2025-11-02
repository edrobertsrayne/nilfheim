_: {
  flake.modules.home.neovim = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      lazy.plugins.vim-tmux-navigator = {
        package = pkgs.vimPlugins.vim-tmux-navigator;

        cmd = [
          "TmuxNavigateLeft"
          "TmuxNavigateDown"
          "TmuxNavigateUp"
          "TmuxNavigateRight"
        ];

        keys = [
          {
            key = "<C-h";
            action = "<cmd><C-U>TmuxNavigateLeft<cr>";
            desc = "Move to left window";
            mode = "n";
          }
          {
            key = "<C-j>";
            action = "<cmd><C-U>TmuxNavigateDown<cr>";
            desc = "Move to bottom window";
            mode = "n";
          }
          {
            key = "<C-j>";
            action = "<cmd><C-U>TmuxNavigateUp<cr>";
            desc = "Move to top window";
            mode = "n";
          }
          {
            key = "<C-l>";
            action = "<cmd><C-U>TmuxNavigateRight<cr>";
            desc = "Move to right window";
            mode = "n";
          }
        ];
      };
    };
  };
}
